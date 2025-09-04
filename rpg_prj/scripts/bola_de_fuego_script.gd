# NOTE: HECHIZO DE ATAQUE PARA EL HECHICERO

class_name bola_de_fuego extends Node2D

###

# [SOLUCIONADO]
# BUG: ESTAN MAL APLICADAS LAS FISICAS AL NODO, LAS BOLAS DE FUEGO CAEN PARA ABAJO
# EN VEZ DE SEGUIR EL RECORRIDO, ADEMAS, SE INSTANCIAN COMO HIJO DEL PERSONAJE Y
# NO DE LA ESCENA DLE PERSONALE EN GENERAL, POR LO QUE CUANDO EL PERSONAJE SE MUEVE
# LAS BOLAS DE FUEGO TAMBIEN.

# [SOLUCIONADO]
# BUG: CUANDO EL JUGADOR SE HACERCA DEMASIADO A UN LUGAR DONDE LA BOLITA COLISIONAL,
# DIRECTAMENTE NI SIQUIERA SPAWNEA.

# [HECHO]
# TODO: EL TIMER DEBE REINICIARSE CADA VEZ QUE SE DEJA DE PRESIONAR "wasd", NO SOLO PARARSE.

# [SOLUCINADO]
# BUG: LA ANMACIÓN DE DESTRUCCION SE BUGUEA POR PROBLEMA DE FISICAS CON EL MISMO HECHIZO,
# POR QUE ESTÁ COLISIONANDO CON SIGO MISMO, COSAS QUE NO DEBERÍA.

###

# ATRIBUTOS
var _nodo_CB : CharacterBody2D
var _direccion_mov : Vector2
var _velocidad_lanzamiento : int
var _anim_bola_fuego : AnimatedSprite2D
var _hay_colision : bool
var _sonido_8bit : AudioStreamPlayer
var _estado_en_movimiento : bool
var _animacion_destruccion : AnimationPlayer
var _poder_ataque : int
# var _nodo_colision : CollisionShape2D
var _nodo_colision_golpe : CollisionShape2D

# METODOS
func _ready() -> void:
	self._nodo_CB = $hechizo_body_2D
	self._anim_bola_fuego = $hechizo_body_2D/AnimatedSprite2D
	self._direccion_mov = Vector2()
	self._velocidad_lanzamiento = 600
	self._hay_colision = false
	self._sonido_8bit = $fx_8bit
	self._estado_en_movimiento = true
	self._animacion_destruccion = $AnimationPlayer
	self._poder_ataque = 10
	# self._nodo_colision = $hechizo_body_2D/colsion_entorno
	self._nodo_colision_golpe = $hechizo_body_2D/Area2D/colision_golpe
	
	# NOTE: CORRE LA ANIMACIÓN DEL SPRITE
	self._anim_bola_fuego.play()
	self._sonido_8bit.play()

func get_poder_ataque() -> int:
	return self._poder_ataque

func establecer_direccion(dir : Vector2) -> void:
	self._direccion_mov = dir
	self._direccion_mov = self._direccion_mov.normalized()

# NOTE: SI EL HECHIZO COLISIONA CON ALGO, FRENA SU RECORRIDO
# Y EJECUTA SU ANIMACION DE DESTRUCIÓN.
func _eliminar_al_colisionar() -> void:
	self._estado_en_movimiento = false
	# NOTE: ELIMINACIÓN DE COLISION SINCRONIZADA
	self._nodo_colision_golpe.call_deferred("set", "disabled", true)
	self._animacion_destruccion.play("anim_destruccion")

func _mover_entidad() -> void:
	if self._estado_en_movimiento:
		self._nodo_CB.velocity = self._direccion_mov * self._velocidad_lanzamiento
		if self._nodo_CB.move_and_slide():
			self._eliminar_al_colisionar()

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "anim_destruccion":
		self.call_deferred("queue_free")

# NOTE: DETECCION Y MANEJO DE ENTIDAD ATACADA
func _on_area_2d_body_entered(body : Node2D) -> void:
	var entidad_enemigo : Node2D = null
	
	if body.name == "enemigo_body_2D":
		entidad_enemigo = body.get_parent()
		entidad_enemigo.quitar_salud(self._poder_ataque)
		self._eliminar_al_colisionar()

# NOTE: METODO PRINCIPAL PARA FISICAS
func _physics_process(delta: float) -> void:
	self._mover_entidad()


# DEPRECATED: CODIGO NO USADO
	# self._eliminar_al_colisionar()
	# self._nodo_colision.disabled = true
	# self._nodo_colision_golpe.disabled = true

# NOTE: HECHIZO DE ATAQUE PARA EL HECHICERO

class_name bola_de_fuego extends Node2D

###

# [SOLUCIONADO]
# BUG: ESTAN MAL APLICADAS LAS FISICAS AL NODO, LAS BOLAS DE FUEGO CAEN PARA ABAJO
# EN VEZ DE SEGUIR EL RECORRIDO, ADEMAS, SE INSTANCIAN COMO HIJO DEL PERSONAJE Y
# NO DE LA ESCENA DLE PERSONALE EN GENERAL, POR LO QUE CUANDO EL PERSONAJE SE MUEVE
# LAS BOLAS DE FUEGO TAMBIEN.

###

# ATRIBUTOS
var _nodo_CB : CharacterBody2D
var _direccion_mov : Vector2
var _velocidad_lanzamiento : int
var _anim_bola_fuego : AnimatedSprite2D
var _hay_colision : bool
var _sonido_8bit : AudioStreamPlayer

# METODOS
func _ready() -> void:
	self._nodo_CB = $CharacterBody2D
	self._anim_bola_fuego = $CharacterBody2D/AnimatedSprite2D
	self._direccion_mov = Vector2()
	self._velocidad_lanzamiento = 20000
	self._hay_colision = false
	self._sonido_8bit = $fx_8bit
	
	# NOTE: CORRE LA ANIMACIÓN DEL SPRITE
	self._anim_bola_fuego.play()

func establecer_direccion(dir : Vector2) -> void:
	self._direccion_mov = dir
	self._direccion_mov = self._direccion_mov.normalized()

func _eliminar_al_colisionar() -> void:
	if self._hay_colision:
		self.queue_free()

func lanzar_sonido_fx() -> void:
	self._sonido_8bit.play()

func _physics_process(delta: float) -> void:
	self._nodo_CB.velocity = self._direccion_mov * self._velocidad_lanzamiento * delta
	self._hay_colision = self._nodo_CB.move_and_slide()
	self._eliminar_al_colisionar()

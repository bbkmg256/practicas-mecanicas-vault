
class_name enemigo extends Node2D

###

# TODO: LAS COLISIONES NO SE ESTÁN DETECTANDO EN ESTA ENTIDAD, REVISAR QUE PASA.

# TODO: TERMINAR ANIMACIONES.

# [POR EL MOMENTO DESACTIVADA]
# BUG: (_detectar_deteminar_colision()) EL ATRIBUTO "name" DE "colision_detectada"
# EN OCACIONES NO ES ADMINITO Y EXPLOTA EL JUEGO.

###

# ATRIBUTOS
# var _nodo_area : Area2D
var _salud : int
var _velocidad_movimiento : int
var _direccion_mov : Vector2
var _jugador_visto : bool
var _jugador = Node2D
var _animacion_enemigo : AnimationPlayer
var _sprite : Sprite2D
var _nodo_cb : CharacterBody2D

# METODOS
func _ready() -> void:
	# self._nodo_area = $Area2D
	self._salud = 80
	self._direccion_mov = Vector2()
	self._velocidad_movimiento = 40
	self._jugador_visto = false
	self._animacion_enemigo = $AnimationPlayer
	self._sprite = $enemigo_body_2D/Sprite2D
	self._nodo_cb = $enemigo_body_2D

func get_salud() -> int:
	return self._salud

func _rotar_sprite(valor : bool) -> void:
	self._sprite.flip_h = valor

func _perseguir_jugador() -> void:
	if not self._jugador_visto:
		if self._animacion_enemigo.current_animation == "anim_caminar":
			self._animacion_enemigo.stop()
			self._animacion_enemigo.seek(0.0)
		return
	self._direccion_mov = self._nodo_cb.global_position - self._jugador.global_position
	self._direccion_mov = self._direccion_mov.normalized() * -1
	# print(self._direccion_mov)
	self._nodo_cb.velocity = self._direccion_mov * self._velocidad_movimiento
	self._nodo_cb.move_and_slide()
	self._animacion_enemigo.play("anim_caminar")

# NOTE: DETERMINA CON QUE NODO SE COLISIONA
func _detectar_deteminar_colision() -> void:
	var colision_detectada : CharacterBody2D = null

	for i in self._nodo_cb.get_slide_collision_count():
		colision_detectada = self._nodo_cb.get_slide_collision(i).get_collider()
		# print(colision_detectada.name)
		if colision_detectada != null and colision_detectada.name == "hechizo_body_2D":
			print("[LOG] Detección de colision funcional")

# NOTE: PERSEGUIR AL JUGADOR CUANDO ENTRA EN EL AREA
func _on_area_2d_body_entered(body : Node2D) -> void:
	# print(body.name)
	if body.name == "jugador_body_2D":
		self._jugador_visto = true
		self._jugador = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "jugador_body_2D":
		self._jugador_visto = false

# NOTE: DETECTA SI EL ENTE ESTÁ MUERTO Y LO ELIMINA DE MEMORIA
func _destruir_entidad() -> void:
	if self._salud <= 0:
		self.queue_free()
		print("[LOG] Enemigo muerto")

# NOTE: SI EL ENEMIGO RECIBE DAÑO, QUITA PORCENTAJE DE VIDA
func quitar_salud(poder_golpe : int) -> void:
	self._salud -= poder_golpe
	self._destruir_entidad() 

# REVIEW: VER QUE CARAJOS VOY A HACER CON ESTO POR QUE NO ESTA MUY CORRECTOVICH
# NOTE: SOLO FISICAS
func _physics_process(delta: float) -> void:
	self._perseguir_jugador()
	# self._detectar_deteminar_colision()

# NOTE: SOLO LOGICA
# func _process(delta: float) -> void:
# 	self._destruir_entidad()



# DERPECATED: CODIGO NO USADO

# 	# print(self._jugador.global_position)
# 	self._direccion_mov = self._jugador.global_position - self._nodo_area.global_position
# 	self._direccion_mov = Vector2(sign(self._direccion_mov.x), sign(self._direccion_mov.y))
# 	# print(self._direccion_mov)
# 	if self._direccion_mov.x < 0:
# 		self._nodo_area.global_position.x -= self._velocidad_movimiento * delta
# 		self._rotar_sprite(false)
# 	if self._direccion_mov.y < 0:
# 		self._nodo_area.global_position.y -= self._velocidad_movimiento/float(2) * delta
# 	if self._direccion_mov.x > 0:
# 		self._nodo_area.global_position.x += self._velocidad_movimiento * delta
# 		self._rotar_sprite(true)
# 	if self._direccion_mov.y > 0:
# 		self._nodo_area.global_position.y += self._velocidad_movimiento/float(2) * delta



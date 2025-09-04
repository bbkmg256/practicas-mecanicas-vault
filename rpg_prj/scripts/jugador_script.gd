
class_name jugador extends Node2D

# SEÑALES
signal lanzar_hechizo

###

# [SOLUCIONADO]
# BUG: ("_rotar_sprite(dir: int)") AL MANTENER PRESIONADO CUALQUIER BOTON DE EJE "Y"
# Y PRESIONAR EL INVERSO A LA DIRECCION ACTUAL EN EJE "X", EL SPRITE
# NO ROTA HASTA QUE SE SUELTE EL BOTON DEL EJE "Y".

# [HECHO]
# TODO: REMOVER EL CODIGO DEL NODO HIJO "CharacterBody2D", ASOCIARLO AL NODO PADRE
# "Node2D" Y OPERAR AL JUGADOR EMPLEANDO DENTRO DEL CODIGO UNA REFERENCIA AL NODO
# "CharacterBody2D", ASÍ EL CODIGO QUEDA ASOCIADO AL NODO PADRE.

# NOTE: NO SE MUY BIEN DONDE DEBERÍA INSTANCIAR LA BOLITA DE FUEGO QUE LANZA EL HECHICERO
# ASUMO QUE EN EL MAPA, PERO ME GENERA PROBLEMAS PARA PASARLE LA DIRECCION A DONDE DEBE IR.

# TODO: LIMPIAR LA INSTANCIA DE LA BOLA DE FUEGO CUANDO COLISIONA CON ALGO, O CUANDO
# SE RECORRE UNA CANTIDAD DE PIXELES DETERMINADA.

# [HECHO]
# TODO: GERERAR UN TICK DE ESPERA PARA QUE HAYA UN INTERVALO DE LANZAMIENTO DE LA
# BOLITA DE FUEGO, ASÍ NO SE LANZA VARIAS INSTANCIAS DE GOLPE SI SE MANTIENEN
# "WASD" PRESIONADO.

# [SOLUCIONADO]
# BUG: AL LANZAR EL HECHIZO HACIA ABAJO, NO SE INTANCIA CORRECTAMENTE Y EL MISMO
# DESAPARECE O DIRECTAMENTE NI APARECE.

# [SOLUCIONADO]
# BUG: EL HECHIZO CUENTA A SI MISMO COMO COLISION PARA ELIMINARSE.

# [HECHO]
# TODO: INSTANCIAR EL HECHIZO EN LA ESCENA DEL MAPA, NO COMO HIJO DEL PJ.

###

# ATRIBUTOS
var _nodo_CB : CharacterBody2D
var _vida : int
var _velocidad_movimiento : int
var _direccion_mov : Vector2
var _direccion_ataque : Vector2
var _sprite : Sprite2D
var _anim_pj : AnimationPlayer
var _tiempo_espera_hechizo : Timer

# METODOS
func _ready() -> void:
	self._nodo_CB = $jugador_body_2D
	self._vida = 100
	self._velocidad_movimiento = 200
	self._direccion_mov = Vector2()
	self._direccion_ataque = Vector2()
	self._sprite = $jugador_body_2D/Sprite2D
	self._anim_pj = $anim_jugador
	self._tiempo_espera_hechizo = $Timer

func get_direccion_ataque() -> Vector2:
	return self._direccion_ataque

# NOTE: RETORNA LA POSICION GLOBAL (NO DEPENDE DEL PADRE) DEL NODO HIJO "CharacterBody2D"
func get_posicion_pj() -> Vector2:
	return self._nodo_CB.global_position

# NOTE: LOGS
func _imprimir_logs() -> void:
	# print("[LOG] DIRECCION MOV. -> " + str(self._direccion_mov))
	# print("[LOG] DIRECCION ATQ. -> " + str(self._direccion_ataque))
	# print("[LOG] PROPIEDAD VELOCITY -> " + str(self.velocity))
	pass

# NOTE: INVIERTE HORIZONTALMENTE EL SPRITE
func _rotar_sprite(dir: float) -> void:
	if dir == float(0):
		return
	# NOTE: ROTA A LA IZQUIERDA
	if dir < float(0):
		self._sprite.flip_h = false
	# NOTE: ROTA A LA DERECHA
	if dir > float(0):
		self._sprite.flip_h = true

# NOTE: REPRODUCE UNA ANIMACION CUANDO SE CAMINA
func _reproducir_animacion_caminar(dir : Vector2) -> void:
	# HACK: FUNCIONA, PERO NO ME DEJA CONFORME
	if dir != Vector2(0,0):
		if self._anim_pj.current_animation == "anim_idle":
			self._anim_pj.stop()
			self._anim_pj.seek(0.0)
		self._anim_pj.play("anim_caminar")
		return
	if self._anim_pj.current_animation == "anim_caminar":
		self._anim_pj.stop()
		self._anim_pj.seek(0.0)
	self._anim_pj.play("anim_idle")

# NOTE: MUEVE AL PERSONAJE
func _mover_jugador() -> void:
	# NOTE: DIRECCIONES PARA EJE X
	self._direccion_mov.x = Input.get_axis("ui_left", "ui_right")
	# NOTE: DIRECCIONES PARA EJE Y
	self._direccion_mov.y = Input.get_axis("ui_up", "ui_down")
	
	# NOTE: VECTOR NORMALIZADO
	self._direccion_mov = self._direccion_mov.normalized()
	
	# NOTE: PROPIEDADES EXCLUSIVA DE LOS NODOS QUE HEREDAN DE "PhysicsBody2D"
	self._nodo_CB.velocity = self._velocidad_movimiento * self._direccion_mov
	self._nodo_CB.move_and_slide()

# NOTE: LANZA ATAQUE
func _lanzar_hechizo() -> void:
	#self._imprimir_logs()
	# NOTE: DIRECCIONES PARA EJE X
	self._direccion_ataque.x = Input.get_axis("MOVER_IZQUIERDA_A", "MOVER_DERECHA_D")
	# NOTE: DIRECCIONES PARA EJE Y
	self._direccion_ataque.y = Input.get_axis("MOVER_ARRIBA_W", "MOVER_ABAJO_S")
	if self._tiempo_espera_hechizo.is_stopped():
		# NOTE: REINICIA EL TIMER
		self._tiempo_espera_hechizo.start(0.0)

# NOTE: EL TIMER DE LANZAMIENTO DEL HECHIZO, SE PARA SI NO SE ESTA PRESIONANDO NADA
func _on_timer_timeout() -> void:
	# HACK: POR EL MOMENTO Y PARA LA PRUEBA
	if self._direccion_ataque != Vector2(0, 0):
		emit_signal("lanzar_hechizo")
		return
	self._tiempo_espera_hechizo.stop()

# NOTE: METODO PRINCIPAL DE PROCESO DE FÍSICAS (EN BUCLE)
func _physics_process(delta: float) -> void:
	#self._imprimir_logs()
	self._mover_jugador()
	self._rotar_sprite(self._direccion_mov.x)
	self._reproducir_animacion_caminar(self._direccion_mov)	
	self._lanzar_hechizo()




# DEPRECATED: CODIGO SIN USAR

#if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
#if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):

#self.velocity.x = self._velocidad_movimiento * self._direccion_mov.x * delta
#self.velocity.y = self._velocidad_movimiento * self._direccion_mov.y * delta

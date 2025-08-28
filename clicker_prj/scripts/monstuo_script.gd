# NOTE: ESTE SCRIPT HEREDA DEL NODO/CLASE "Node2D"
extends Node2D

###

# NOTE: DEFINICIÓN DE SEÑALES
signal finalizado

####

# VARIABLES
#var punto_golpe = 1
var vida_monstruo : int
# @onready var animation_player = $AnimationPlayer
var animacion_monstruo : AnimationPlayer
var prob_critico : float

# GETTERS/SETTERS
func get_vida_monstruo() -> int:
	return self.vida_monstruo

# METODOS
# NOTE: SE EJECUTA UNA SOLA VEZ
func _ready() -> void:
	self.vida_monstruo = 50
	self.animacion_monstruo = $AnimationPlayer
	# NOTE: CONECTA A SEÑAL "animation_finished" de AnimationPlayer
	self.animacion_monstruo.connect(
		"animation_finished", 
		Callable(
			self, "_on_animation_finished"
	))
	# NOTE: ESTA ES LA FORMA MODERNA DE ESRIBIR LO DE ARRIBA (GODOT 4.0)
	# animacion_monstruo.animation_finished.connect("_on_animation_finished")
	
	if not self.animacion_monstruo.is_playing():
		self.animacion_monstruo.play("spawn_anim")
	print("[LOG] Vida del monstruo -> " + str(self.vida_monstruo)) # LOG
	#print("[LOG] > Funcional") # LOG

func sigue_vivo() -> bool:
	return self.vida_monstruo > 0

func animacion_muerto() -> void:
	if not self.animacion_monstruo.is_playing():
		self.animacion_monstruo.play("ded_anim")
		#print("[LOG] > funciona")
	#print("[LOG] > Monstruo muerto!")

# NOTE: METODO DE SEÑAL PERSONALIZADA PARA ANIMACIÓN
func _on_animation_finished(nombre_anim: String) -> void:
	if nombre_anim == "ded_anim":
		emit_signal("finalizado")

# NOTE: DETECTA EVENTOS SOBRE EL AREA2D DEL NODO, Y VERIFICA SI EL EVENTO ES UN CLICK
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# NOTE: VERIFICA QUE EL EVENTO, SEA UN ENVENTO DEL MAOUSE
	if event is InputEventMouseButton:
		# NOTE: VERIFICA QUE EL EVENTO DEL MOUSE, SEA UN CLICK (IZQUIERDO EN ESTE CASO)
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			# NOTE: EVITA QUE SE LEAN EVENTOS DEL CLICK MIENTRAS EL MONSTRUO ESTÁ MUERTO
			if not self.sigue_vivo():
				return
				#print("[ LOG ] HAS MATADO AL MONSTRUO") # LOG
			# REVIEW: LA ANIMACIÓN ES MUY LENTA
			# (SOLUCIONADO: ANIMACIÓN REINICIADA CON CADA TOQUE)
			if self.animacion_monstruo.is_playing() and self.animacion_monstruo.current_animation == "pop_anim":
				self.animacion_monstruo.stop()
				self.animacion_monstruo.seek(0.0, true)
			self.animacion_monstruo.play("pop_anim")
			
			#self.prob_critico = randf()
			#print(self.prob_critico)
			#print(float(1)/2)
			# NOTE: EN GODOT, LAS DIVISIONES SE TRATAN COMO ENTERAS, SE DEBE EXPLICITAR CON FLOTANTES
			# SI SE ESPERA RESULTADOS FLOTANTES, DE LO COTRARIO GODOT DEVUELVE UN ENTERO.
			#print(randf() <= float(1)/2)
			# NOTE: PEQUEÑO SISTEMAS DE PROBABILIDAD DE DAÑO CRITICO
			if randf() <= float(1)/10:
				self.vida_monstruo -= 10
				print("[LOG] Critico de 10 PD aplicado!")
			else:
				self.vida_monstruo -= 1
			
			# HACK: ESTO ESTÁ MAL, PERO PARA PROBAR SIRVE XD
			if self.vida_monstruo < 0:
				print("[LOG] > Vida del monstruo -> " + str(0)) # LOG
			else:
				print("[LOG] > Vida del monstruo -> " + str(self.vida_monstruo)) # LOG
			
			# HACK: MALAZO, PERO DESPUES VEO QUE ONDA
			if self.vida_monstruo <= 0:
				print("[LOG] > Monstruo muerto!")

func _process(delta: float) -> void:
	# NOTE: ANIMACIÓN CONSTANTE EN IDLE
	if not self.animacion_monstruo.is_playing():
		self.animacion_monstruo.play("idle_anim")

# DEPRECATE: CODIGO SIN USAR
# if not animacion_monstruo.is_playing():
	# animacion_monstruo.play("pop_anim")

class_name UI extends Control

###

# TODO: ANIMAR EL INDICADOR DE BALAS

###

# SEÑALES
signal cargar_bala
signal girar_tambor

# ATRIBUTOS
var _anim_pick_cargar_bala : AnimationPlayer
var _anim_pick_girar_tambor : AnimationPlayer
#var _anim_pick_cantidad_balas : AnimationPlayer

# METODOS
func _ready() -> void:
	self._anim_pick_cargar_bala = $cargar_bala/pick_cargar_bala
	self._anim_pick_girar_tambor = $girar_tambor_arma/pick_girar_tambor
	#self._anim_pick_cantidad_balas = $cantidad_balas/n_balas/pick_cantidad_balas

# NOTE: EVENTO PARA EL PANEL DE CARGA DE BALA
func _on_cargar_bala_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			#print("[LOG] Bala cargada!")
			emit_signal("cargar_bala")
			if not self._anim_pick_cargar_bala.is_playing():
				self._anim_pick_cargar_bala.play("pick_anim")
				#self._anim_pick_cantidad_balas.play("pick_anim_cant_ba")

# NOTE: EVENTO PARA EL PANEL DE GIRO DE TAMBOR DEL ARMA
func _on_girar_tambor_arma_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			#print("[LOG] Tambor girado!")
			emit_signal("girar_tambor")
			if not self._anim_pick_girar_tambor.is_playing():
				self._anim_pick_girar_tambor.play("pick_anim_gi_ta")

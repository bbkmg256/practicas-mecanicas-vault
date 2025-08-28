class_name UI extends Control

# SEÑALES
signal cargar_bala
signal girar_tambor

# NOTE: EVENTO PARA EL PANEL DE CARGA DE BALA
func _on_cargar_bala_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			#print("[LOG] Bala cargada!")
			emit_signal("cargar_bala")

# NOTE: EVENTO PARA EL PANEL DE GIRO DE TAMBOR DEL ARMA
func _on_girar_tambor_arma_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			#print("[LOG] Tambor girado!")
			emit_signal("girar_tambor")

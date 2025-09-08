extends Control

# ATRIBUTOS
var _anim_ui : AnimationPlayer
var _etiqueta : Label

# METODOS
func _ready() -> void:
	self._anim_ui = $AnimationPlayer
	self._etiqueta = $Panel/HBoxContainer/Label

func set_punto_ataque(valor : int) -> void:
	self._etiqueta.text = str(valor)

func ejercutar_animacion() -> void:
	self._anim_ui.play("spawn_anim")

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "spawn_anim":
		self.queue_free()


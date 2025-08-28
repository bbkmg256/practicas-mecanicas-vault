# NOTE: ESTA CLASE ES MOMENTANE, LA LOGICA DE ACÁ SE TRASLADARA A OTRA PARTE
class_name Escena extends Node2D

# ATRIBUTOS
var _ui: Control
var _arma : Node2D

# METODOS
func _ready() -> void:
	self._ui = preload("res://escenas/ui_juego.tscn").instantiate()
	self._arma = preload("res://escenas/arma.tscn").instantiate()
	
	self._arma.position = Vector2(800/2, 600/2)
	self._ui.position = Vector2(113, 417)
	
	self.add_child(self._arma); self.add_child(self._ui)
	
	self._ui.cargar_bala.connect(_on_cargar_bala_en_arma)
	self._ui.girar_tambor.connect(_on_girar_tambor_de_arma)

func _on_cargar_bala_en_arma() -> void:
	#print("[LOG] A")
	self._arma.cargar_arma()

func _on_girar_tambor_de_arma() -> void:
	#print("[LOG] B")
	self._arma.girar_tambor_de_arma()

func _process(delta: float) -> void:
	self._ui.get_node("cantidad_balas/n_balas").text = str(self._arma.get_cantidad_balas())
	#pass
	#self._ui.text = str(self._arma.get_cantidad_balas())

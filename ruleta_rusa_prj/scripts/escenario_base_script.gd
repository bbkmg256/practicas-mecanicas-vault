# NOTE: ESTA CLASE ES MOMENTANE, LA LOGICA DE ACÁ SE TRASLADARA A OTRA PARTE
class_name Escena extends Node2D

###

# TODO: AGREGAR ANIMACIÓN DE DESTELLO POST-DISPARO (HECHO)

###

# ATRIBUTOS
var _ui: Control
var _arma : Node2D
var _fx_destello : Control

# METODOS
func _ready() -> void:
	self._ui = preload("res://escenas/ui_juego.tscn").instantiate()
	self._arma = preload("res://escenas/arma.tscn").instantiate()
	self._fx_destello = preload("res://escenas/fx_destello.tscn").instantiate()
	
	self._arma.position = Vector2(800/2, 600/2)
	self._ui.position = Vector2(100, 417)
	
	self.add_child(self._arma); self.add_child(self._ui); self.add_child(self._fx_destello)
	
	self._ui.cargar_bala.connect(_on_cargar_bala_en_arma)
	self._ui.girar_tambor.connect(_on_girar_tambor_de_arma)
	# NOTE: LA SEÑAL SE RECIBE PERO EL METODO SOLO SE LLAMA 1 VEZ
	self._arma.arma_disparada.connect(_on_arma_disparada, CONNECT_ONE_SHOT)
	
	self._ui.get_node("cantidad_balas/n_balas").text = str(self._arma.get_cantidad_balas())
	self._fx_destello.visible = false

func _on_cargar_bala_en_arma() -> void:
	self._arma.cargar_arma()
	self._ui.get_node("cantidad_balas/n_balas").text = str(self._arma.get_cantidad_balas())
	#print("[LOG] A")

func _on_girar_tambor_de_arma() -> void:
	self._arma.girar_tambor_de_arma()
	#print("[LOG] B")

# NOTE: METODO PARA SEÑAL DE ARMA DISPARADA
func _on_arma_disparada() -> void:
	#print("[LOG] Funcional")
	# NOTE: LA ANIMACIÓN DEL ARMA NO SE VERÁ
	self._fx_destello.visible = true
	self._fx_destello.get_node("anim_fx_destello").play("anim_destello")

# REVIEW: ESTO SE TIENE QUE ELIMINAR, ME COJE EL RENDIMIENTO
# POR ALGO QUE SE VA A HACER UNA SOLA VEZ
#func _process(delta: float) -> void:
	#if self._arma.get_arma_disparada():
		#print("[LOG] Funcional")
	#pass
	#self._ui.text = str(self._arma.get_cantidad_balas())

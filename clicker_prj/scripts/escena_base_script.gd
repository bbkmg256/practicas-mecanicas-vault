# Script para nivel base de prueba

# NOTE: HEREDA DEL NODO/CLASE Node2D
extends Node2D

###

# VARIABLES
# NOTE: PRECARGA LA ESCENA DEL MONSTRUO A MEMORIA
var monstruo_escena : Object
var ui_vida_escena : Object
var instancia_mons : Node2D
var instancia_ui_vida : Control
var ubicacion_monstuo : Vector2
var etiqueta_vida : Label
#var player_anim_mons :  = null

# METODOS
func _ready() -> void:
	self.monstruo_escena = preload("res://escenas/monstuo.tscn") # QUE PELOTUDO, ESCRIBÍ MAL EL NOMBRE DE LA ESCENA
	self.ui_vida_escena = preload("res://escenas/ui_vida.tscn")
	self.instancia_mons = null
	self.instancia_ui_vida = self.ui_vida_escena.instantiate()
	self.instancia_ui_vida.position = Vector2((200/2)+20, (100/2)-10)
	self.etiqueta_vida = self.instancia_ui_vida.get_node("porcentaje_vida")
	add_child(self.instancia_ui_vida)
	self.ubicacion_monstuo = Vector2(200/2, 100/2)

func _instanciar_entidad() -> void:
	# NOTE: INSTANCIA DE LA ESCENA DEL MONS.
	self.instancia_mons = self.monstruo_escena.instantiate()
	self.instancia_mons.position = self.ubicacion_monstuo
	# NOTE: AÑADE LA INSTANCIA AL ARBOL DE NODOS DE LA ESCENA
	add_child(self.instancia_mons)
	# NOTE: CONECTA A SEÑAL PERSONALIZADA "finalizado" DE LA ENTIDAD MONSTRUO
	self.instancia_mons.connect(
		"finalizado",
		Callable(
			self, "_on_anim_muerte_finalizada"
	))
	# NOTE: ESTA ES LA FORMA MODERNA DE ESRIBIR LO DE ARRIBA (GODOT 4.0)
	# instancia_mons.finalizado.connect(_on_anim_muerte_finalizada)

	#print(instancia_mons.get_vida_monstruo())

func _librerar_entidad() -> void:
	# NOTE: LIBERA LA INSTANCIA DE LA MEMORIA Y LIBERA LA REFERENCIA
	self.instancia_mons.queue_free()
	self.instancia_mons = null
	#print("[LOG] > MAL")

# BUG: ESTO SE EJECUTA INDEFINIDAMENTE (SOLUCINADO)
func _on_anim_muerte_finalizada():
	self._librerar_entidad()
	#print("[LOG] > Funciona")

# NOTE: SE LLAMA DURANTE TODA LA VIDA DE EJECUCION DEL JUEGO
func _process(delta: float) -> void:
	# BUG: "instancia_mons" siempre es null, por que no se esta
	# referenciando al objeto directamente en la variable. (SOLUCIONADO)
	if instancia_mons == null:
		print("[LOG] > Un monstruo ah aparecido, destruyelo!")
		self._instanciar_entidad()
	# NOTE: ESTABLECE LA CANTIDAD DE VIDA DEL MOSNTRUO EN EL HUD
	# HACK: ESTO SE PODRÍA HACER DE OTRA MANERA
	if self.instancia_mons.get_vida_monstruo() < 0:
		self.etiqueta_vida.text = str(0)
	else:
		self.etiqueta_vida.text = str(self.instancia_mons.get_vida_monstruo())
	# BUG: LA ANIMACIÓN DE MUERTE NO SE REPRODUCE (SOLUCINADO)
	if self.instancia_mons != null and not self.instancia_mons.sigue_vivo():
		self.instancia_mons.animacion_muerto()
		#_librerar_entidad()
	#print("[LOG] > Se ejecuta siempre")

# NOTE: MAPA DE TESTEO

class_name mapa_base extends Node2D

###

# NOTE: LA INSTANCIACIÓN DE LA CLASE PURA SOLO SE USA
# PARA LOGICCA Y ABSTRACCIÓN, NO PARA LAS ESCENAS EN SI.
#self._jugador = jugador.new()

# NOTE: HAY QUE MODIFICAR AL ENEMIGO, JUGADOR Y HECHIZO, REALMENTE
# TODOS DEBEN TENER UN AREA2D PARA DEFINIR QUE SI ENTRA ALGO EN ÉL
# PRODUZCA TAL ACCIÓN, COMO DAÑO O BRINDAR SALUD O COSAS ASÍ, LAS
# COLISSION PROPIO DE LOS NODOS BODY, SERÍAN MAS PARA TRABAJAR CON
# EL ENTORNO, QUE PARA LAS INTERACCIONES CON OTRAS ENTIDADES.

# NOTE: EL NODO DEL TILE DEL MAPA ESTÁ MAL UBICADO A PROPOSITO PARA TESTEO,
# TAMBIEN SE CAMBIO LA DIMENSION DEL VIEWPORT, NO COINCIDE CON LA GRILLA, PERO
# POR EL MOMENTO SE QUEDA ASÍ.

###

# ATRIBUTOS
var _sountrack_mapa : AudioStreamPlayer

var _marcador_pj : Marker2D
var _jugador : Node2D

# NOTE: "_hechizo_fuego" SERÁ LA INSTANCIACIÓN DE ESTE RECURSO
var _recurso_bola_de_fuego : Object
var _hechizo_fuego : Node2D

var _marcador_enemigo : Marker2D
var _enemigo : Node2D

# NOTE: UI PUNTOS DE DAÑO
var _ui_recurso : Object
var _ui_puntos_golpe : Control

# METODOS
func _ready() -> void:
	self._sountrack_mapa = $soundtrack_mapa
	self._jugador = preload("res://escenas/jugador.tscn").instantiate()
	self._marcador_pj = $marcador_pj
	self._recurso_bola_de_fuego = preload("res://escenas/bola_de_fuego.tscn")
	self._hechizo_fuego = null
	self._enemigo = preload("res://escenas/enemigo.tscn").instantiate()
	self._marcador_enemigo = $marcador_enemigo
	self._ui_recurso = preload("res://escenas/ui_puntos_golpe.tscn")
	
	# NOTE: CORRE LA SOUNTRACK DEL MAPA
	# self._sountrack_mapa.play()
	
	self.add_child(self._jugador); self.add_child(self._enemigo)
	
	self._jugador.lanzar_hechizo.connect(_on_lanzar_hechizo)

	# NOTE: EL PJ SE INSTANCIA EN LA POSICION DEL NODO MARCADOR
	self._jugador.global_position = self._marcador_pj.position

	# NOTE: FUNCIONA PARA LO MISMO DE ARRIBA XD
	self._enemigo.global_position = self._marcador_enemigo.position

# NOTE: SEÑAL DE SOUNTRACK FINALIZADO
func _on_soundtrack_mapa_finished() -> void:
	self._sountrack_mapa.play()
	pass

func _on_lanzar_hechizo() -> void:
	self._hechizo_fuego = self._recurso_bola_de_fuego.instantiate()
	self.add_child(self._hechizo_fuego)
	self._hechizo_fuego.impacto_enemigo.connect(_on_impacto_enemigo)

	# HACK: MOMENTANEO HASTA ENCONTRAR UNA MEJOR FORMA DE POSICIONAR LA BOLA DE FUEGO
	self._hechizo_fuego.position = self._jugador.get_posicion_pj() + (Vector2(20, 20) * self._jugador.get_direccion_ataque())
	#print("[LOG] POSICIÓN NODO CB -> " + str(self._nodo_CB.position))
	#print("[LOG] VALOR DE VECTOR A SUMAR -> " + str(Vector2(20, 20) * self._direccion_ataque))
	#print("[LOG] POSICIÓN HECHIZO -> " + str(self._hechizo_fuego.position))

	self._hechizo_fuego.establecer_direccion(self._jugador.get_direccion_ataque())

func _on_impacto_enemigo() -> void:
	# print("Funciona")
	self._ui_puntos_golpe = self._ui_recurso.instantiate()
	self.add_child(self._ui_puntos_golpe)
	self._ui_puntos_golpe.set_punto_ataque(self._hechizo_fuego.get_poder_ataque())
	self._ui_puntos_golpe.global_position = self._enemigo.get_node("enemigo_body_2D").global_position
	self._ui_puntos_golpe.ejercutar_animacion()

# func _process(delta: float) -> void:
# 	self._enemigo.atacar_jugador(self._jugador.get_posicion_pj())

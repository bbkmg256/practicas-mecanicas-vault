class_name Arma extends Node2D

###

# TODO: VERIFICAR QUE SI SE DISPARA UNA VEZ EL ARMA
# (SIN IMPORTAR LA CANTIDAD DE BALAS)
# NO SE PUEDA VOLVER A DISPARAR.

# TODO: AL GATILLAR, EL TAMBOR DEL REVOLVER SIGUE GIRANDO
# POR ENDE SE DEBERÍA SEGUIR CALCULANDO LA PROBABILIDAD DE
# DISPADO.

# TODO: EL SONIDO DE LA ATURDICIÓN HAY QUE MEJORARLA PARA QUE
# TAPE AL SONIDO DEL ARMA DESPUES DEL DISPARO.

# TODO: HAY QUE AGREGAR ALGUNA ANIMACIÓN AL ARMA, O ENCONTRAR
# ALGUN ARMA ANIMADA.

###

# ATRIBUTOS
var _cantidad_balas : int
var _probabilidad_disparo : float
var _probilidad_giro_de_tambor_de_arma : float
var _sonido_disparo : AudioStreamPlayer
var _sonido_click_arma : AudioStreamPlayer
var _sonido_carga_arma : AudioStreamPlayer
var _sonido_giro_tambor_arma : AudioStreamPlayer
var _sonido_aturdidor : AudioStreamPlayer
var _arma_disparada : bool
var _tambor_girado : bool
var _n_gatillados : int

# GETTERS/SETTERS
func get_cantidad_balas() -> int:
	return self._cantidad_balas

# METODOS
func _ready() -> void:
	self._cantidad_balas = 0
	self._probabilidad_disparo = float(self._cantidad_balas)/6
	# NOTE: ES "-1" PARA VERIFICAR QUE EL GIRO SE HACE ANTES DEL GATILLADO
	self._probilidad_giro_de_tambor_de_arma = -1
	self._sonido_disparo = $sonido_disparo
	self._sonido_click_arma = $sonido_click_arma
	self._sonido_carga_arma = $sonido_carga_arma
	self._sonido_giro_tambor_arma = $sonido_giro_tambor_arma
	self._sonido_aturdidor = $sonido_aturdidor
	self._arma_disparada = false
	self._tambor_girado = false
	self._n_gatillados = 6 - self._cantidad_balas

func _hay_balas_en_recamara() -> bool:
	return self._cantidad_balas > 0
	#print(self._cantidad_balas > 0)

# NOTE: SE PUEDE USAR FUERA DE LA CLASE
func cargar_arma() -> void:
	if self._arma_disparada:
		print("[LOG] Estas muerto, vuelve a reiniciar!")
		return
	if self._cantidad_balas < 6:
		self._cantidad_balas += 1
		self._probabilidad_disparo = float(self._cantidad_balas)/6
		self._sonido_carga_arma.play()
		print("[LOG] Bala cargada!")
		return
	print("[LOG] Arma totalmente cargada!")

# NOTE: SIMULA EL GIRO DEL TAMBOR DEL REVOLVER ANTES DE GATILLAR
# Y TAMBIÉN DA LA PROBABILIDAD DEL EVENTO PARA EL DISPARO
func girar_tambor_de_arma() -> void:
	if self._arma_disparada:
		print("[LOG] Estas muerto, vuelve a reiniciar!")
		return
	self._probilidad_giro_de_tambor_de_arma = randf()
	self._tambor_girado = true
	if not self._sonido_carga_arma.is_playing():
		self._sonido_giro_tambor_arma.play()
	print("[LOG] Tambor girado")

func _recalculo_de_probabilidad_de_arma() -> void:
	self._probilidad_giro_de_tambor_de_arma = randf()

# NOTE: GATILLADO DEL ARMA
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if self._arma_disparada:
				print("[LOG] Estas muerto, vuelve a reiniciar!")
				return
			if not self._hay_balas_en_recamara():
				self._sonido_click_arma.play()
				print("[LOG] No hay balas en la recamara!")
				return
			# NOTE: PUTA MADRE, ES UN LIO ESTA MECÁNICA
			# NOTE: SI EL TAMBOR SE GUIRA ANTES DE GATILLAR
			if self._tambor_girado:
				if self._probilidad_giro_de_tambor_de_arma <= self._probabilidad_disparo:
					#print("[LOG] Probabilidad de disparo -> " + str(self._probabilidad_disparo))
					self._cantidad_balas -= 1
					self._sonido_disparo.play()
					self._sonido_aturdidor.play()
					self._arma_disparada = true
					print("[LOG] Arma disparada, estas muerto!")
					return
				self._tambor_girado = false
				print("[LOG] Arma gatillada, seguís vivo!")
				self._sonido_click_arma.play()
				return
			self._recalculo_de_probabilidad_de_arma()
			# NOTE: SI EL TAMBOR NO SE GIRA ANTES DE GATILLAR, PERO
			# LA BALA NO ESTÁ EN LA RECAMARA
			if not (self._probilidad_giro_de_tambor_de_arma <= self._probabilidad_disparo) and self._n_gatillados > 1:
				self._n_gatillados -= 1
				print("[LOG] Arma gatillada, seguís vivo!")
				self._sonido_click_arma.play()
				print(self._n_gatillados)
				return
			# NOTE: SI EL TAMBOR NO SE GIRA ANTES DE GATILLAR, PERO
			# LA BALA ESTÁ EN LA RECAMARA
			self._cantidad_balas -= 1
			self._sonido_disparo.play()
			self._sonido_aturdidor.play()
			self._arma_disparada = true
			self._tambor_girado = false
			print("[LOG] Arma disparada, estas muerto!")


# DEPRECATED: CODIGO SIN USAR

			#if not self._probilidad_giro_de_tambor_de_arma > -1:
				#print("[LOG] No se giró el tambor del arma!")
				#return
			#print(self._probilidad_giro_de_tambor_de_arma)
		#print("[LOG] Prob. evento -> " + str(self._probilidad_giro_de_tambor_de_arma))
		#print(self._probabilidad_disparo)
		#print(self._probilidad_giro_de_tambor_de_arma <= self._probabilidad_disparo)

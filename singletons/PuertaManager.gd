extends Node

signal puerta_registrada

var primera_puerta: Node = null
var segunda_puerta: Node = null

# Rutas de los sonidos
@export var sonido_primera: AudioStream = preload("res://sonidos/artefacto.mp3")
@export var sonido_misma: AudioStream = preload("res://sonidos/artefacto_2.mp3")
@export var sonido_diferente: AudioStream = preload("res://sonidos/artefacto_3.mp3")
@export var sonido_explosion: AudioStream = preload("res://sonidos/explosion.mp3")

@onready var reproductor: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	# Muy importante: añadir el reproductor al árbol para que pueda sonar
	add_child(reproductor)
	get_tree().connect("node_removed", Callable(self, "_on_scene_change"))

func _on_scene_change(node):
	# Si es el root de la escena, limpiar datos
	if node == get_tree().current_scene:
		_reset()

func registrar_puerta(puerta: Node):
	emit_signal("puerta_registrada", puerta)
	if primera_puerta == null:
		primera_puerta = puerta
		print("Primera puerta registrada: ", puerta.name)
		_reproducir_sonido(sonido_primera)
	elif segunda_puerta == null:
		segunda_puerta = puerta
		print("Segunda puerta registrada: ", puerta.name)
		
		if primera_puerta == segunda_puerta:
			print("Misma puerta seleccionada, limpiando...")
			_reproducir_sonido(sonido_misma)
			_reset()
		else:
			_reproducir_sonido(sonido_diferente)
			var jugador = get_tree().get_first_node_in_group("jugador")
			if jugador:
				if not jugador.is_connected("intercambio_finalizado", Callable(self, "_on_intercambio_finalizado")):
					jugador.connect("intercambio_finalizado", Callable(self, "_on_intercambio_finalizado"))
			else:
				print("Jugador no encontrado, intercambio inmediato.")
				_intercambiar_posiciones()
				_reset()

func _on_intercambio_finalizado():
	_intercambiar_posiciones()

func _intercambiar_posiciones():
	if primera_puerta and segunda_puerta:
		var explosion_scene := preload("res://escenas/explosion_intercambio.tscn")
		
		var explosion = explosion_scene.instantiate()
		var explosion2 = explosion_scene.instantiate()
		
		get_tree().current_scene.add_child(explosion)
		get_tree().current_scene.add_child(explosion2)
		
		explosion.global_position = primera_puerta.global_position
		explosion2.global_position = segunda_puerta.global_position
		explosion.get_node("CPUParticles2D").emitting = true
		explosion2.get_node("CPUParticles2D").emitting = true
		_reproducir_sonido(sonido_explosion)
		var pos_temp = primera_puerta.global_position
		primera_puerta.global_position = segunda_puerta.global_position
		segunda_puerta.global_position = pos_temp
		print("Puertas intercambiadas:", primera_puerta.name, " <-> ", segunda_puerta.name)
		_reset()

func _reset():
	primera_puerta = null
	segunda_puerta = null

func _reproducir_sonido(sonido: AudioStream):
	if sonido:
		reproductor.stream = sonido
		reproductor.play()

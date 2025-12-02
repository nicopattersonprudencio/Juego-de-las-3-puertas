extends Node

signal opcion_seleccionada(opcion_texto: String, opcion_index: int)

var opcion_escena: PackedScene = preload("res://escenas/caja_opciones.tscn")
var opciones: Array = []
var opcion_actual := 0

var is_opciones_active = false

var posicion_base: Vector2 = Vector2.ZERO
const ESPACIADO_Y := 60

@onready var sonido_cambio := preload("res://sonidos/select_option.wav")
@onready var sonido_eleccion := preload("res://sonidos/eleccion.mp3")
@onready var player_cambio := AudioStreamPlayer.new()
@onready var player_seleccionado := AudioStreamPlayer.new()

func _ready():
	add_child(player_cambio)
	add_child(player_seleccionado)
	player_cambio.volume_db = -6
	player_seleccionado.volume_db = 2

func mostrar_opciones(textos: Array[String], posicion: Vector2):
	limpiar_opciones()
	posicion_base = posicion
	opcion_actual = 0
	is_opciones_active = true
	
	for i in range(textos.size()):
		var opcion = opcion_escena.instantiate()
		opcion.global_position = posicion + Vector2(0, i * ESPACIADO_Y)
		opcion.get_node("MarginContainer/Label").text = textos[i]
		get_tree().get_root().add_child(opcion)
		opciones.append(opcion)

	_actualizar_resaltado()

func limpiar_opciones():
	for o in opciones:
		o.queue_free()
	opciones.clear()
	is_opciones_active = false
	
func _unhandled_input(event):
	if opciones.size() == 0:
		return

	if event.is_action_pressed("ui_down"):
		opcion_actual = (opcion_actual + 1) % opciones.size()
		_actualizar_resaltado()

	elif event.is_action_pressed("ui_up"):
		opcion_actual = (opcion_actual - 1 + opciones.size()) % opciones.size()
		_actualizar_resaltado()

	elif event.is_action_pressed("interactuar"):
		player_seleccionado.stream = sonido_eleccion
		player_seleccionado.play()
		var texto = opciones[opcion_actual].get_node("MarginContainer/Label").text
		var index = opcion_actual
		emit_signal("opcion_seleccionada", texto, index)
		limpiar_opciones()

func _actualizar_resaltado():
	for i in range(opciones.size()):
		var label = opciones[i].get_node("MarginContainer/Label")
		label.add_theme_color_override("font_color", Color(0.74, 0.6, 0.1) if i == opcion_actual else Color.BLACK)
		
	if is_opciones_active and sonido_cambio:
		player_cambio.stream = sonido_cambio
		player_cambio.play()

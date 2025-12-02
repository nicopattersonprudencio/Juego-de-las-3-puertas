extends Node2D

var intro = false
var texto_lv = preload("res://escenas/texto_lv.tscn")
var instance_lv = texto_lv.instantiate()

@onready var jugador = $Node2D/jugador
@onready var camara = $Camera2D
@onready var audio = $AudioStreamPlayer

func _ready():
	var jugador = get_tree().get_first_node_in_group("jugador")
	instance_lv.z_index = 1000
	add_child(instance_lv)
	if GameVariables.escena_2_cambiada:
		instance_lv.z_index = 1000
		instance_lv.global_position.y -= 180
		add_child(instance_lv)
		intro = true
		jugador.global_position = Vector2(-32, -265)
		jugador.sprite.texture = load("res://sprites - copia/monje_frente.png")
		
func _process(delta):
	jugador = get_tree().get_first_node_in_group("jugador")
	if jugador.global_position.y <= 0 and jugador.global_position.y >= -240:
		camara.global_position.y = jugador.global_position.y
	
	
	if intro:
		if  not GameVariables.escena_2_cambiada:
			camara.global_position.y = 0
		else:
			camara.global_position.y = -240
		intro = false
	
func reiniciar():
	intro = true

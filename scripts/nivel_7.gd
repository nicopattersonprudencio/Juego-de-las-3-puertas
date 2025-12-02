extends Node2D

@onready var puerta = $Node2D/StaticBody2D/Sprite2D
@onready var puerta2 = $Node2D/StaticBody2D2/Sprite2D
@onready var puerta3 = $Node2D/StaticBody2D3/Sprite2D

var texto_lv = preload("res://escenas/texto_lv.tscn")
var instance_lv = texto_lv.instantiate()

func _ready():
	instance_lv.z_index = 1000
	instance_lv.global_position.y += 20
	add_child(instance_lv)
	var jugador = get_tree().get_first_node_in_group("jugador")
	
	if GameVariables.nivel_8_alcanzado:
		puerta.global_position.x = 0
		puerta2.global_position.x = 64
		puerta3.global_position.x = -64
	
	if GameVariables.escena_7_cambiada:
		jugador.global_position = puerta2.global_position + Vector2(0, 30)
		jugador.sprite.texture = load("res://sprites - copia/monje_frente.png")

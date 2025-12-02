extends Node2D

var texto_lv = preload("res://escenas/texto_lv.tscn")
var instance_lv = texto_lv.instantiate()

func _ready():
	instance_lv.z_index = 1000
	instance_lv.global_position.y += 20
	add_child(instance_lv)
	var jugador = get_tree().get_first_node_in_group("jugador")
	
	if GameVariables.escena_3_cambiada:
		jugador.global_position = Vector2(65, -40)
		jugador.sprite.texture = load("res://sprites - copia/monje_frente.png")

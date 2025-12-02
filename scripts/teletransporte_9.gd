extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_8.tscn")
	GameVariables.escena_8_cambiada = true
	GameVariables.nivel = 8
	GameVariables.nivel_9_alcanzado = true
	GameVariables.escena_9_cambiada = false

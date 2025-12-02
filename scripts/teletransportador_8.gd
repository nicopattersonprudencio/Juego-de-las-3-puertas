extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_7.tscn")
	GameVariables.escena_7_cambiada = true
	GameVariables.nivel = 7
	GameVariables.nivel_8_alcanzado = true
	GameVariables.escena_8_cambiada = false

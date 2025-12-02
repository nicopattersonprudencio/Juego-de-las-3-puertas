extends StaticBody2D

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_2.tscn")
	GameVariables.escena_2_cambiada = true
	GameVariables.nivel = 2
	GameVariables.nivel_3_alcanzado = true
	GameVariables.escena_3_cambiada = false

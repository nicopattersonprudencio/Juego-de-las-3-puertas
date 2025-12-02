extends StaticBody2D

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_4.tscn")
	GameVariables.escena_4_cambiada = true
	GameVariables.nivel = 4
	GameVariables.nivel_5_alcanzado = true
	GameVariables.escena_5_cambiada = false

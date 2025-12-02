extends StaticBody2D

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_3.tscn")
	GameVariables.nivel = 3
	GameVariables.nivel_4_alcanzado = true
	GameVariables.escena_3_cambiada = true
	GameVariables.escena_4_cambiada = false

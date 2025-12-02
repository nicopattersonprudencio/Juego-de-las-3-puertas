extends StaticBody2D

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_6.tscn")
	GameVariables.escena_6_cambiada = true
	GameVariables.nivel = 6
	GameVariables.nivel_7_alcanzado = true
	GameVariables.escena_7_cambiada = false

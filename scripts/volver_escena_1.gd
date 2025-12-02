extends StaticBody2D

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/primer_nivel.tscn")
	GameVariables.escena_2_cambiada = false
	GameVariables.nivel = 1
	GameVariables.nivel_2_alcanzado = true

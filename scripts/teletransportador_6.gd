extends StaticBody2D

var musica = preload("res://musica/No_se_donde_estoy_pero_se_siente_epico.mp3")

func _on_area_2d_body_entered(body):
	var tree = get_tree()
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	tree.change_scene_to_file("res://escenas/nivel_5.tscn")
	GameVariables.escena_5_cambiada = true
	GameVariables.nivel = 5
	GameVariables.nivel_6_alcanzado = true
	GameVariables.escena_6_cambiada = false
	MusicPlayer.play_music(musica)

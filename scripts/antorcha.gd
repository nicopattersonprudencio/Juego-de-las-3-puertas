extends Node2D

@onready var particles = $CPUParticles2D

func _ready():
	particles.visible = false

func _process(delta):
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador.global_position.y - 25 <= global_position.y and not GameVariables.escena_2_cambiada:
		particles.visible = true
	
	if jugador.global_position.y + 25 >= global_position.y and GameVariables.escena_2_cambiada:
		particles.visible = true

extends StaticBody2D

var jugador_en_rango = false

const intro_lines: Array[String] = [
	"Una estatua de piedra sujeta una tabla",
	"Lees las escrituras grabadas en la piedra"
]

const mensaje_lines: Array[String] = [
	"'Al menos una puerta solo dice la verdad'",
	"'Al menos una puerta solo miente'",
	"'Solo una es la salida'"
]

func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	if body.name == "jugador":
		jugador_en_rango = true

func _on_area_2d_body_exited(body):
	if body.name == "jugador":
		jugador_en_rango = false

func _unhandled_input(event):
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		var lines_to_show: Array[String] = []

		if not GameVariables.estatua_nivel_1_mostrada:
			lines_to_show.append_array(intro_lines)
			GameVariables.estatua_nivel_1_mostrada = true

		lines_to_show.append_array(mensaje_lines)
		DialogManager.start_dialog(Vector2(-130, 125), lines_to_show)

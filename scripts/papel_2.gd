extends StaticBody2D

var jugador_en_rango = false
var es_papel = false

@onready var sonido = $AudioStreamPlayer

const lines: Array[String] = [
	"Hola",
	"Parece ser que nos volvemos a encontrar",
	"Me alegra que hayas llegado hasta aquí",
	"Pero todo se pondrá mas difícil a partir de ahora",
	"Es posible que te estes preguntando...",
	"¿Porque no te digo las respuestas de las pruebas?",
	"La razón es simple",
	"Las habitaciones cambian periódicamente",
	"Para todos los visitantes las pruebas son distintas",
	"y solo ciertas cosas permanecen igual",
	"como esta habitación",
	"aquí se te otorgará un artefacto",
	"su forma y uso varia según el usuario",
	"pero todos se activan de la misma forma",
	"solo acércate a una puerta y pulsa 'x'",
	"Como ultimo consejo...",
	"ten en cuenta siempre las 3 reglas",
	"'Al menos una puerta solo dice la verdad'",
	"'Al menos una perta solo miente'",
	"'Solo una es la salida'",
	"Buena suerte",
	"-Wisy"
]

func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body):
	if body.name == "jugador":
		jugador_en_rango = true
	es_papel = true

func _on_area_2d_body_exited(body):
	if body.name == "jugador":
		jugador_en_rango = false
	es_papel = false

func _unhandled_input(event):
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		DialogManager.start_dialog(Vector2(-130, 125), lines)
		if es_papel:
			sonido.play()
			es_papel = false

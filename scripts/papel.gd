extends StaticBody2D

var jugador_en_rango = false
var es_papel = false

@onready var sonido = $AudioStreamPlayer2

const lines: Array[String] = [
	"Hola",
	"no se quien estará leyendo esto",
	"pero me gustaria felicitarte",
	"has superado tu primera prueba",
	"puede que haya sido un paso pequeño",
	"pero el primer paso suele ser el mas importante",
	"Sé que tienes preguntas",
	"yo tambien las tenia...",
	"de hecho, las sigo teniendo",
	"ahora...",
	"te dire lo que sé",
	"¿Que es este sitio?",
	"Nadie lo sabe",
	"pero todo el mundo viene por el mismo motivo",
	"Hacer realidad sus deseos",
	"¿es esto posible?",
	"desconozco la respuesta",
	"pero las cosas aqui superan la ciencia ficción",
	"¿Ahora que?",
	"Hay un sitio donde nos reunimos todos",
	"lo llamamos el campamento",
	"tu sigue avanzando y lo encontrarás",
	"buena suerte",
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
		DialogManager.start_dialog(Vector2(-130, -90), lines)
		if es_papel:
			sonido.play()
			es_papel = false

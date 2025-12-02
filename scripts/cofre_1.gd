extends StaticBody2D

var jugador_en_rango = false

@onready var sonido = $AudioStreamPlayer
@onready var sprite = $Sprite2D

# --- Sprites del cofre ---
@export var sprite_cerrado: Texture2D
@export var sprite_abierto: Texture2D

const lines: Array[String] = [
	"Has obtenido el báculo de intercambio"
]

const lines1: Array[String] = [
	"Un cofre vacío"
]

func _ready():
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
	# Restaurar sprite según estado guardado en GameVariables
	if GameVariables.intercambiar:
		sprite.texture = sprite_abierto
	else:
		sprite.texture = sprite_cerrado

func _on_area_2d_body_entered(body):
	if body.name == "jugador":
		jugador_en_rango = true

func _on_area_2d_body_exited(body):
	if body.name == "jugador":
		jugador_en_rango = false

func _unhandled_input(event):
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		if not GameVariables.intercambiar:
			# Primer uso: mostrar texto, reproducir sonido y abrir cofre
			DialogManager.start_dialog(Vector2(-130, 125), lines)
			sonido.play()
			if sprite_abierto:
				sprite.texture = sprite_abierto
			GameVariables.intercambiar = true  # Guardamos el estado
		else:
			# Si ya estaba abierto
			DialogManager.start_dialog(Vector2(-130, 125), lines1)

extends StaticBody2D

@onready var puerta3 = $Sprite2D
@onready var puerta2 = $"../StaticBody2D2/Sprite2D"
@onready var puerta = $"../StaticBody2D/Sprite2D"
var jugador_en_rango = false
var opciones_visibles = false
var debe_mostrar_opciones = false
var unico = false
var pulsar_x = true
var opciones: Array[String] = ["No", "Si"]

const lines: Array[String] = [
	"'La puerta verde es la salida'",
	"'La salida no esta en el centro'",
	"¿Quieres abrir esta puerta?"
]

const lines2: Array[String] = [
	"No sientes la necesidad de hacer esto"
]

func _ready():
	$Sprite2D/Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Sprite2D/Area2D.body_exited.connect(_on_area_2d_body_exited)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "jugador":
		jugador_en_rango = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "jugador":
		jugador_en_rango = false
		opciones_visibles = false

func _unhandled_input(event):
	if !jugador_en_rango or opciones_visibles:
		return
	#no permite ninguna interacción mientras se pulsa x
	var jugador = get_tree().get_first_node_in_group("jugador")
	if jugador and jugador.en_intercambio:
		return
	
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		pulsar_x = false
		if not GameVariables.nivel_9_alcanzado:
			debe_mostrar_opciones = true
			if not DialogManager.is_connected("dialogo_terminado", Callable(self, "_on_dialogo_terminado")):
					DialogManager.dialogo_terminado.connect(_on_dialogo_terminado)
		
			DialogManager.start_dialog(Vector2(-130, 125), lines)
		else:
			unico = true
			_on_opcion_seleccionada("texto",1)
	
	if jugador_en_rango and Input.is_action_just_pressed("intercambiar") and pulsar_x and GameVariables.intercambiar:
		if GameVariables.nivel_9_alcanzado:
			DialogManager.start_dialog(Vector2(-130, 125), lines2)
		else:
			PuertaManager.registrar_puerta(puerta3)

func _on_opcion_seleccionada(texto,index):
	opciones_visibles = false
	debe_mostrar_opciones = false
	
	if index == 1 and unico:
		if int(puerta.global_position.x) == 64 and int(puerta2.global_position.x) == -64 and int(puerta3.global_position.x) == 0:
			GameVariables.nivel_8_alcanzado = true
			var tree = get_tree()
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			GameVariables.nivel = 9
			tree.change_scene_to_file("res://escenas/nivel_9.tscn")
		else:
			var jugador = get_tree().get_first_node_in_group("jugador")
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			jugador.global_position = Vector2(0, 90)
			puerta.global_position.x = -64
			puerta2.global_position.x = 0
			puerta3.global_position.x = 64
	unico = false
	pulsar_x = true
	
func _on_dialogo_terminado():
	if debe_mostrar_opciones:
		opciones_visibles = true
		unico = true
		OpcionManager.mostrar_opciones(opciones, Vector2(-130, 0))
	
	if not OpcionManager.is_connected("opcion_seleccionada", Callable(self, "_on_opcion_seleccionada")):
		OpcionManager.opcion_seleccionada.connect(_on_opcion_seleccionada)

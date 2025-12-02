extends StaticBody2D

@onready var padre = get_parent().get_parent()

var jugador_en_rango = false
var opciones_visibles = false
var debe_mostrar_opciones = false
var unico1 = false
var pulsar_x = true
var no_z = false
var contador = 0

var opciones: Array[String] = ["No", "Si"]

const lines: Array[String] = [
	"'Esta puerta es la salida'",
	"¿Quieres abrir esta puerta?"
]

const lines1: Array[String] = [
	"No sientes la necesidad de abrir esta puerta"
]

const lines2: Array[String] = [
	"No sientes la necesidad de hacer esto"
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
		opciones_visibles = false

func _unhandled_input(event):
	if !jugador_en_rango or opciones_visibles:
		return
	
	if jugador_en_rango and Input.is_action_just_pressed("interactuar"):
		if contador == 0:
			pulsar_x = false
		
		if DialogManager.is_connected("dialogo_terminado", Callable(self, "_on_dialogo_terminado")):
			DialogManager.dialogo_terminado.disconnect(Callable(self, "_on_dialogo_terminado"))
		if DialogManager.is_connected("dialogo_terminado", Callable(self, "_pulsar_x")):
			DialogManager.dialogo_terminado.disconnect(Callable(self, "_pulsar_x"))
		
		if contador > 0:
			contador -= 1
			
		if not GameVariables.nivel_5_alcanzado:
			debe_mostrar_opciones = true
			if not DialogManager.is_connected("dialogo_terminado", Callable(self, "_on_dialogo_terminado")) and contador == 0:
					DialogManager.dialogo_terminado.connect(_on_dialogo_terminado)
		
			DialogManager.start_dialog(Vector2(-130, 125), lines)
		else:
			unico1 = true
			_on_opcion_seleccionada("texto",1)
	
	if jugador_en_rango and Input.is_action_just_pressed("intercambiar") and pulsar_x and GameVariables.intercambiar:
		if DialogManager.is_connected("dialogo_terminado", Callable(self, "_on_dialogo_terminado")):
			DialogManager.dialogo_terminado.disconnect(Callable(self, "_on_dialogo_terminado"))
		if DialogManager.is_connected("dialogo_terminado", Callable(self, "_pulsar_x")):
			DialogManager.dialogo_terminado.disconnect(Callable(self, "_pulsar_x"))
		contador = 2
		if not DialogManager.is_connected("dialogo_terminado", Callable(self, "_pulsar_x")):
			DialogManager.dialogo_terminado.connect(_pulsar_x)
		DialogManager.start_dialog(Vector2(-130, 125), lines2)

func _pulsar_x():
	pulsar_x = true

func _on_opcion_seleccionada(texto,index):
	opciones_visibles = false
	debe_mostrar_opciones = false
	
	if index == 1 and unico1:
		if GameVariables.nivel_5_alcanzado:
			DialogManager.start_dialog(Vector2(-130, 125), lines1)
			
		else:
			var jugador = get_tree().get_first_node_in_group("jugador")
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			jugador.global_position = Vector2(0, 70)
	unico1 = false
	pulsar_x = true

func _on_dialogo_terminado():
	if debe_mostrar_opciones:
		opciones_visibles = true
		unico1 = true
		OpcionManager.mostrar_opciones(opciones, Vector2(-130, 0))
	
	if not OpcionManager.is_connected("opcion_seleccionada", Callable(self, "_on_opcion_seleccionada")):
		OpcionManager.opcion_seleccionada.connect(_on_opcion_seleccionada)

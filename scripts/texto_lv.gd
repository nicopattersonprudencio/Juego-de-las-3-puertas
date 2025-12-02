extends Node2D

@onready var label = $Label

var pixel_size := 300.0
var pixelando = false

func _process(delta):
	if pixelando:
		var mat = label.material as ShaderMaterial
		mat.set_shader_parameter("viewport_size", get_viewport().size)

		# Reducir pixelado progresivamente
		if pixel_size > 1:
			pixel_size -= delta * 50
			mat.set_shader_parameter("pixel_size", pixel_size)
		else:
			# Cuando termina, eliminar el nodo
			queue_free()
	else:
		modificar_nivel()

func modificar_nivel():
	label.text = "nivel " + str(GameVariables.nivel)
	label.material = label.material.duplicate() # aseguramos material único
	pixelando = true

extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var fade_to_normal = true
var especial = false

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black" and fade_to_normal:
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")

	elif anim_name == "fade_to_normal":
		color_rect.visible = false
		if especial:
			on_transition_finished.emit()
	elif anim_name == "fade_to_black" and not fade_to_normal:
		on_transition_finished.emit()

func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")

# Función que pone el ColorRect completamente negro y visible
func set_black():
	color_rect.visible = true
	color_rect.modulate = Color.BLACK

# Función que reproduce fade_to_normal y luego desactiva el color_rect
func fade_out():
	if not color_rect.visible:
		color_rect.visible = true
		color_rect.modulate = Color.BLACK  # asegura que empiece en negro
	especial = true
	animation_player.play("fade_to_normal")
	fade_to_normal = true

func fade_black():
	fade_to_normal = false
	color_rect.visible = true
	animation_player.play("fade_to_black")

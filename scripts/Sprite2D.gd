extends CharacterBody2D

var nivel_1
@export var speed: float = 70.0

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var ultima_direccion := ""
var en_intercambio := false

signal intercambio_finalizado

func _ready():
	nivel_1 = get_tree().get_first_node_in_group("nivel_1")
	
	if PuertaManager.is_connected("puerta_registrada", Callable(self, "_on_puerta_registrada")) == false:
		PuertaManager.connect("puerta_registrada", Callable(self, "_on_puerta_registrada"))
	
	animation.connect("animation_finished", Callable(self, "_on_animacion_finalizada"))

func _physics_process(delta: float) -> void:
	var detener = false
	
	if nivel_1 and nivel_1.has_method("parar_jugador"):
		detener = nivel_1.parar_jugador()
	
	# Si está en animación de intercambio o hay diálogos/menús
	if en_intercambio or DialogManager.is_dialog_active or OpcionManager.is_opciones_active or detener:
		velocity = Vector2.ZERO
		return
	
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		
		if Input.is_action_pressed("ui_down"):
			if animation.current_animation == "caminar_perfil_derecho" and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
				animation.play("caminar_perfil_derecho")
			elif animation.current_animation != "caminar_frente":
				animation.play("caminar_frente")
				sprite.flip_h = false
			ultima_direccion = "frente"
		
		if Input.is_action_pressed("ui_up"):
			if animation.current_animation == "caminar_perfil_derecho" and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
				animation.play("caminar_perfil_derecho")
			elif animation.current_animation != "caminar_espalda":
				animation.play("caminar_espalda")
				sprite.flip_h = false
			ultima_direccion = "espalda"
		
		if Input.is_action_pressed("ui_right"):
			if animation.current_animation == "caminar_frente" and Input.is_action_pressed("ui_down"):
				animation.play("caminar_frente")
			elif animation.current_animation == "caminar_espalda" and Input.is_action_pressed("ui_up"):
				animation.play("caminar_espalda")
			elif animation.current_animation != "caminar_perfil_derecho":
				animation.play("caminar_perfil_derecho")
				sprite.flip_h = false
			ultima_direccion = "derecha"
				
		if Input.is_action_pressed("ui_left"):
			if animation.current_animation == "caminar_frente" and Input.is_action_pressed("ui_down"):
				animation.play("caminar_frente")
			elif animation.current_animation == "caminar_espalda" and Input.is_action_pressed("ui_up"):
				animation.play("caminar_espalda")
			elif animation.current_animation != "caminar_perfil_derecho":
				animation.play("caminar_perfil_derecho")
				sprite.flip_h = true
			ultima_direccion = "izquierda"
	else:
		if animation.is_playing():
			animation.stop()
		match ultima_direccion:
			"frente":
				sprite.texture = load("res://sprites - copia/monje_frente.png")
				sprite.flip_h = false
			"espalda":
				sprite.texture = load("res://sprites - copia/monje_espalda.png")
				sprite.flip_h = false
			"derecha":
				sprite.texture = load("res://sprites - copia/monje_perfil.png")
				sprite.flip_h = false
			"izquierda":
				sprite.texture = load("res://sprites - copia/monje_perfil.png")
				sprite.flip_h = true
			
	velocity = input_vector * speed
	move_and_slide()

func mostrar_frente():
	animation.stop()
	ultima_direccion = "frente"
	sprite.texture = load("res://sprites - copia/monje_frente.png")
	sprite.flip_h = false

func intercambiar():
	if not en_intercambio:
		en_intercambio = true
		velocity = Vector2.ZERO
		animation.play("intercambiar")
		
func _on_animacion_finalizada(anim_name: String):
	if anim_name == "intercambiar":
		en_intercambio = false
		ultima_direccion = "espalda"
		sprite.texture = load("res://sprites - copia/monje_espalda.png")
		sprite.flip_h = false
		emit_signal("intercambio_finalizado")

func _on_puerta_registrada(puerta: Node):
	intercambiar()

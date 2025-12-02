extends Node2D

@onready var layer = $antorchaLayer


var una = true
var musica = preload("res://musica/No_se_donde_estoy_pero_se_siente_epico.mp3")
var intro = true
var etapa = 0
var reproduciendo = false
var parar = false
var volviendo
var jugador
var texto_lv = preload("res://escenas/texto_lv.tscn")
var instance_lv = texto_lv.instantiate()

@onready var canvas = $CanvasLayer
@onready var antorcha7 = $antorchaLayer/antorcha7
@onready var antorcha8 = $antorchaLayer/antorcha8
@onready var antorcha9 = $antorchaLayer/antorcha9
@onready var antorcha10 = $antorchaLayer/antorcha10
@onready var antorcha11 = $antorchaLayer/antorcha11
@onready var timer = $Timer
@onready var sonido = $AudioStreamPlayer

func _ready():
	jugador = get_tree().get_first_node_in_group("jugador")
	
	if GameVariables.nivel_2_alcanzado:
		instance_lv.z_index = 1000
		instance_lv.global_position.y += 85
		canvas.add_child(instance_lv)
		intro = false
		jugador.global_position = Vector2(-32, -44)
		jugador.sprite.texture = load("res://sprites - copia/monje_frente.png")
		layer.layer = 1
	# Posiciones
	antorcha7.global_position = Vector2(-126, -74)
	antorcha8.global_position = Vector2(126, -74)
	antorcha9.global_position = Vector2(-63, -74)
	antorcha10.global_position = Vector2(63, -74)
	antorcha11.global_position = Vector2(0, -74)
	
func _physics_process(delta):
	if intro:
		parar = true
		layer.layer = 2
		antorcha7.visible = false
		antorcha8.visible = false
		antorcha9.visible = false
		antorcha10.visible = false
		antorcha11.visible = false
		timer.start()
		TransitionScreen.set_black()
		intro = false
		#MusicPlayer.play_music(musica)

func reiniciar():
	intro = true

func parar_jugador()-> bool:
	return parar

func _on_timer_timeout():
	match etapa:
		0:
			sonido.play()
			antorcha7.visible = true
			antorcha8.visible = true
		1:
			sonido.play()
			antorcha9.visible = true
			antorcha10.visible = true
		2:
			sonido.play()
			antorcha11.visible = true
		3:
			if una:
				instance_lv.z_index = 1000
				instance_lv.global_position.y += 85
				canvas.add_child(instance_lv)
				una = false
			TransitionScreen.fade_out()
			await TransitionScreen.on_transition_finished
			layer.layer = 1
			if not reproduciendo:
				MusicPlayer.play_music(musica)
				reproduciendo = true
			etapa = 0
			parar = false
			timer.stop()
			return
	etapa += 1
	timer.start()

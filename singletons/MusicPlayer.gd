extends Node

@onready var player := AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Music"
	player.autoplay = false
	player.volume_db = -4

func play_music(stream: AudioStream, volume_db: float = -4.0):
	if player.stream != stream:
		player.stream = stream
		player.stream.loop = true
		player.volume_db = volume_db
		player.play()

extends Node


var total_coins: int = 0
func _ready():
	BackgroundMusic.play()
	#var audio_player = AudioStreamPlayer.new()
	#add_child(audio_player)
	#audio_player.stream = preload("res://audio/coin.wav")
	#audio_player.name = "CoinAudio"
func coin_collected(value: int):
	total_coins += value 
	#$CoinAudio.play()
	EventController.emit_signal("coin_collected", total_coins)

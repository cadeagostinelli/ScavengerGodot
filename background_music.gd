extends AudioStreamPlayer

var background_music_path = "res://audio/Fun_Background.wav"
var game_over_music_path = "res://audio/GAMEOVER.wav"
var win_music_path = "res://audio/winsound.wav"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = load(background_music_path)
	play()
func play_background_music():
	stream = load(background_music_path)
	play()
func play_game_over_music():
	stream = load(game_over_music_path)
	play()
func play_win_music():
	stream = load(win_music_path)
	play()
func stop_music():
	stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

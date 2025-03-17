extends Control

func _ready():
	var title = $Title
	# Resizes node to match screen size
	var screensize = get_viewport().get_size()
	var background = $Background
	var start_button = $Start
	var title_player = AudioStreamPlayer.new()
	add_child(title_player)
	title_player.stream = preload("res://audio/Fun_Background.wav")
	title_player.name = "TitleAudio"
	$TitleAudio.play()
	background.custom_minimum_size = screensize

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1REAL.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

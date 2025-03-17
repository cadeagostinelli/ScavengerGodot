extends Control

	
func _ready():
	var title = $Title
	# Resizes node to match screen size
	var screensize = get_viewport().get_size()
	var background = $Background
	var start_button = $Start
	var title_music = AudioStreamPlayer.new()
	add_child(title_music)
	title_music.stream = preload("res://audio/Audio1.wav")
	title_music.name = "TitleAudio"
	
	background.custom_minimum_size = screensize
	$TitleAudio.play()
	
func _on_start_pressed() -> void:
	$TitleAudio.stop()
	get_tree().change_scene_to_file("res://level1.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

extends CanvasLayer

func _ready() -> void:
	visible = false
	
	var vbox = $VBoxContainer
	vbox.size_flags_horizontal = Control.SIZE_FILL
	vbox.size_flags_vertical = Control.SIZE_FILL
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	var win_label = $VBoxContainer/Label
	win_label.text = "You Win!"
	win_label.add_theme_font_size_override("font_size", 32)

	var score_label = $VBoxContainer/Label2
	score_label.text = "Final Score: " + str(GlobalScore.globalScore)
	score_label.add_theme_font_size_override("font_size", 24)
	
	var highScore_label = $VBoxContainer/Label3
	highScore_label.text = "High Score: " + str(Saveload.highest_record)
	score_label.add_theme_font_size_override("font_size", 24)


	var button = $VBoxContainer/Button
	button.text = "Restart"
	button.custom_minimum_size = Vector2(200, 50)
	

	button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
	vbox.position = Vector2(175, 100)
	BackgroundMusic.stop_music()
	BackgroundMusic.play_win_music()
	
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://level_1REAL.tscn")
	GlobalScore.reset_score()
	BackgroundMusic.play_background_music()
func show_end_screen() -> void:
	visible = true

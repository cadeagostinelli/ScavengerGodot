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

	#var score_label = $VBoxContainer/Label
	#score_label.text = "Final Score: " + str(GlobalScore.globalscore)
	#score_label.add_theme_font_size_override("font_size", 24)

	var button = $VBoxContainer/Button
	button.text = "Restart"
	button.custom_minimum_size = Vector2(200, 50)

	button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func show_end_screen() -> void:
	visible = true

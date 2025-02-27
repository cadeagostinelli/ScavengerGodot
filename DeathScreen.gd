extends Control

func _ready() -> void:
	# Don't want to see it unless called
	visible = false
	
	# Set up as fullscreen overlay
	anchor_right = 1
	anchor_bottom = 1
	offset_right = 0
	offset_bottom = 0
	
	# Make sure it fills the whole screen
	grow_horizontal = 2  # GROW_DIRECTION_BOTH
	grow_vertical = 2    # GROW_DIRECTION_BOTH
	
	# Center the VBoxContainer
	var vbox = $VBoxContainer
	vbox.size_flags_horizontal = SIZE_FILL
	vbox.size_flags_vertical = SIZE_FILL
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Adjust label font size
	var label = $VBoxContainer/Label
	label.add_theme_font_size_override("font_size", 32)
	
	# Set button size directly
	var button = $VBoxContainer/Button
	button.custom_minimum_size = Vector2(200, 50)

func show_death_screen(death_position = null):
	visible = true
	
	# We're treating this as a fullscreen overlay, so no need to position it
	# at the player's death location

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

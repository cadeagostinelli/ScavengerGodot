extends Area2D

@export var end_screen_scene : PackedScene  # Link the end screen scene

func _on_body_entered(body: Node2D) -> void:
	# Only show the end screen if the player is the one entering
	if body.is_in_group("player"):
		if GlobalScore.globalScore > Saveload.highest_record:
			Saveload.highest_record = GlobalScore.globalScore
			Saveload.save_score()
		
		var end_screen = end_screen_scene.instantiate()
		get_tree().current_scene.add_child(end_screen)
		end_screen.show_end_screen()

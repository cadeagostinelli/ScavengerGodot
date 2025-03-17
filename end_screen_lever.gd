extends Area2D



func _on_body_entered(body: Node2D) -> void:
	Saveload.save_score()
	# Get Tree function to a end screen in the future
	

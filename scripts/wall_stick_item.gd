extends Area2D

@export var wall_stick_time: float = 100  # Time player can stick to walls

func _on_body_entered(body):
	if body is Player:  # Check if the player collected the item
		body.enable_wall_stick(wall_stick_time)
		queue_free()

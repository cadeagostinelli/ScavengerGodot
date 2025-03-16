extends Area2D  # Now detects when the player enters

func _ready():
	add_to_group("spikes")
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("Collision detected!")  # Debugging
	if body.is_in_group("player"):
		print("Player hit spikes!")  # Should appear in the console
		body.die()

extends Node2D

var Player = preload("res://scripts/player.gd")

@export var value: int = 1
@export var desired_scale: Vector2 = Vector2(0.5, 0.5) # for scaling the coins

func _ready():
	add_to_group("Coins")
	self.scale = desired_scale # applies consistent scaling
	
func _on_area_2d_body_entered(body):
	if body is Player:
		GameController.coin_collected(value)
		self.queue_free()

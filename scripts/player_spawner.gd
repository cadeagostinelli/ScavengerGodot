## Spawner Script
extends Node2D

var player_scene = preload("res://player.tscn")
var player = null
func _process(_delta):
	if player == null:
		var new_obj = player_scene.instantiate()
		new_obj.position = position
		get_parent().add_child(new_obj)
		player = new_obj


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene() #Change this to be the you died screen when working

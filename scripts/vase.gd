extends Area2D

@export var treasure_scenes: Array  
@onready var break_sound = $vase_break_sound
@onready var vase_position = global_position


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		break_sound.play()
		var num_treasures = 3 
		for i in range(num_treasures):
			var treasure_scene = treasure_scenes[randi() % treasure_scenes.size()] 
			var treasure = treasure_scene.instantiate() 

			treasure.global_position = vase_position

			var launch_velocity = Vector2(randi_range(100, 200), randi_range(-50, 50))
			treasure.linear_velocity = launch_velocity

			treasure.collision_layer = 2 << i
			get_tree().current_scene.add_child(treasure)

		await break_sound.finished
		queue_free() 

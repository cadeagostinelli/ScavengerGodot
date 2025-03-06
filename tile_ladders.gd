extends TileMap

func _on_area_2d_body_entered(body):
	if body is Player:
		Player.on_ladder = true
		

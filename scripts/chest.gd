extends Area2D

@onready var diamond = $Diamond
@onready var open_sprite = $OpenChest
@onready var closed_sprite = $ClosedChest 
@export var treasure_value: int = 300 
@onready var diamondsound = $Diamond/Diamondsound

var opened = false 

func _ready():
	open_sprite.hide() 
	diamond.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not opened:
		opened = true
		closed_sprite.hide()
		open_sprite.show()
		diamond.show()
		diamondsound.play()
		diamond.global_position = global_position + Vector2(0, -20)
		await get_tree().create_timer(1.0).timeout  
		diamond.hide()
		if body.has_method("add_treasure"):
			body.add_treasure(treasure_value)  
		

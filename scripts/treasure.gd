extends RigidBody2D

@export var value: int = 10  
@export var pickup_range: float = 32  
@export var pickup_delay: float = 0.2

@onready var area = $Area2D  
@onready var timer = Timer.new()  

var can_pick_up: bool = false 

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player") and can_pick_up:
		body.add_treasure(value) 
		$CoinAudio.play()
		queue_free() 

# Called when the node is ready
func _ready() -> void:
	area.body_entered.connect(Callable(self, "_on_Area2D_body_entered"))

	add_child(timer)
	timer.one_shot = true
	timer.wait_time = pickup_delay
	timer.connect("timeout", Callable(self, "_on_timeout"))

	timer.start()
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = preload("res://audio/coin.wav")
	audio_player.name = "CoinAudio"
func _on_timeout() -> void:
	can_pick_up = true  
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player"):
			_on_Area2D_body_entered(body)

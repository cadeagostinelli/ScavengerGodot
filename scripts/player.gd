extends CharacterBody2D

@onready var death_screen_scene = preload("res://DeathScreen.tscn") 
@onready var death_screen 

const SPEED = 400.0
const JUMP_VELOCITY = -500.0

@export var fall_damage_threshold: float = 500.0
@export var damage_per_fall: int = 100

var max_fall_speed: float = 0.0

@export var max_health: int = 100
var health: int

func _ready():
	# Set initial health
	health = max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# FALL DAMAGE PORTION
	# Track the max fall speed
	if velocity.y > max_fall_speed:
		max_fall_speed = velocity.y
		
	if is_on_floor():
		if max_fall_speed > fall_damage_threshold:
			take_damage(damage_per_fall)
		# Reset max fall speed
		max_fall_speed = 0.0

func take_damage(amount):
	health -= amount
	print("Took ", amount, " damage! Health: ", health)
	if health <= 0:
		die()
		
func die():
	print("Player has died!")
	# Freeze the camera in place
	var camera = get_viewport().get_camera_2d()
	if camera:
		# If the camera is following the player, detach it
		if camera.get_parent() == self:
			remove_child(camera)
			get_parent().add_child(camera)
	# Instantiate the scene
	var death_screen = death_screen_scene.instantiate()  
	# Add it to the scene tree
	get_tree().current_scene.add_child(death_screen)
	# Get player position before showing the UI
	var player_position = global_position
	# Show the UI with the player's position
	death_screen.show_death_screen(player_position)
	# Remove the player from the scene
	queue_free()
		

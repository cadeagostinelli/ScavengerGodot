extends CharacterBody2D

@onready var death_screen_scene = preload("res://DeathScreen.tscn")
@onready var death_screen
@onready var healthbar = $Healthbar
const SPEED = 400.0
const JUMP_VELOCITY = -500.0
@export var fall_damage_threshold: float = 500.0
@export var max_fall_damage: int = 50
@export var fall_damage_factor: float = 0.1
var max_fall_speed: float = 0.0
var fall_speed: float = 0.0
var previous_fall_speed: float = 0.0 # Store the fall speed from the previous frame
@export var max_health: int = 100
var health: int

func _ready():
	health = max_health
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	previous_fall_speed = fall_speed # Store the current fall speed before updating it.
	fall_speed = abs(velocity.y)
	print("Fall speed: ", fall_speed)

	if is_on_floor():
		if previous_fall_speed > fall_damage_threshold: # Check the previous frame's fall speed
			apply_fall_damage(previous_fall_speed) # Use the previous frame's fall speed
			previous_fall_speed = 0 # reset previous fall speed
			fall_speed = 0 # reset fall speed
func apply_fall_damage(fall_speed: float):
	var damage = fall_speed * fall_damage_factor
	damage = min(damage, max_fall_damage)
	print("Fall damage applied: ", damage)
	take_damage(damage)

func take_damage(amount):
	health -= amount
	healthbar._set_health(health)
	print("Took ", amount, " damage! Health: ", health)
	if health <= 0:
		die()

func die():
	print("Player has died!")
	var camera = get_viewport().get_camera_2d()
	if camera:
		if camera.get_parent() == self:
			remove_child(camera)
			get_parent().add_child(camera)
	var death_screen = death_screen_scene.instantiate()
	get_tree().current_scene.add_child(death_screen)
	var player_position = global_position
	death_screen.show_death_screen(player_position)
	queue_free()

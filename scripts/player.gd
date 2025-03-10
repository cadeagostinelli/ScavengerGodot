class_name Player extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D  # Add this line to reference your AnimatedSprite2D
@onready var death_screen_scene = preload("res://DeathScreen.tscn")
@onready var healthbar = $Healthbar
@onready var ladder_ray_cast: RayCast2D = $LadderRay

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
@export var fall_damage_threshold: float = 800.0
@export var fall_damage_factor: float = 0.05

var max_fall_speed: float = 0.0
var fall_speed: float = 0.0
var previous_fall_speed: float = 0.0 
@export var max_health: int = 100
var health: int
@export var wall_stick_enabled: bool = false
@export var wall_stick_duration: float = 0.0
var wall_stick_timer: float = 0.0

func _ready():
	health = max_health
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	# Gravity
	var ladderCollider = ladder_ray_cast.get_collider()
	
	if ladderCollider: _ladder_climb(delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip sprite based on movement direction
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Manage Fall Speed and Damage
	previous_fall_speed = fall_speed 
	fall_speed = abs(velocity.y)
	if is_on_floor():
		if previous_fall_speed > fall_damage_threshold: 
			apply_fall_damage(previous_fall_speed)
			previous_fall_speed = 0
			fall_speed = 0

	# Wall Stick Mechanics
	var is_touching_wall = is_on_wall()
	if wall_stick_enabled and is_touching_wall:
		# Slowly fall
		velocity.y = 10 
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			if is_on_wall() and velocity.x < 0:
				velocity.x = SPEED * 6
			# On the left side of the wall (player facing right)
			elif is_on_wall() and velocity.x > 0: 
				velocity.x = -SPEED * 6 
			else:
				# If no horizontal direction is pressed, apply a slight push away from the wall
				velocity.x = SPEED * 6 if velocity.x < 0 else -SPEED * 6
			# Temporarily disable wall stick to prevent player from getting stuck
			wall_stick_enabled = false  
			await get_tree().create_timer(0.1).timeout
			wall_stick_enabled = true
				
	if wall_stick_timer > 0:
		wall_stick_timer -= delta
		if wall_stick_timer <= 0:
			wall_stick_enabled = false  # Disable after time expires

	# Animate the player
	update_animation()

	move_and_slide()
	
func _ladder_climb(delta):
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	if direction:velocity = direction * SPEED 
	else:velocity = Vector2.ZERO
	

func update_animation():
	# Determine the appropriate animation based on player state
	if is_on_floor():
		if abs(velocity.x) > 0:
			animated_sprite.play("Walk")
		else:
			animated_sprite.play("Idle")
	else:
		if is_on_wall() and wall_stick_enabled:
			animated_sprite.play("WallStick")
		elif velocity.y < 0:
			animated_sprite.play("Jumping")
		else:
			animated_sprite.play("Jumping")

func apply_fall_damage(fall_speed: float):
	var damage = fall_speed * fall_damage_factor
	#damage = min(damage, max_fall_damage)
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
	
func enable_wall_stick(duration: float):
	wall_stick_enabled = true
	wall_stick_timer = duration
	print("Wall stick enabled for", duration, "seconds!")
	

	

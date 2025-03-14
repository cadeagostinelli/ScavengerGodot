class_name Player extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var death_screen_scene = preload("res://DeathScreen.tscn")
@onready var healthbar = $Healthbar
@onready var ladder_ray_cast: RayCast2D = $LadderRay
@onready var treasure_ui_scene = preload("res://treasure_ui.tscn")
@onready var treasure_ui_instance = treasure_ui_scene.instantiate()
@onready var score_label = treasure_ui_instance.get_node("Label")

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
var is_climbing_ladder: bool = false 

var score: int = 0

func _ready():
	add_to_group("player")
	var audio_player1 = AudioStreamPlayer.new()
	add_child(treasure_ui_instance)
	add_child(audio_player1)
	audio_player1.stream = preload("res://audio/jump.wav")
	audio_player1.name = "JumpSound"
	
	health = max_health
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	# Gravity
	var ladderCollider = ladder_ray_cast.get_collider()
	
	# If the player is on the ladder, disable wall stick
	if ladderCollider:
		_ladder_climb(delta)
		wall_stick_enabled = false  # Disable wall stick when on the ladder
	else:
		# Enable wall stick if the player is not on the ladder and touches the wall
		var is_touching_wall = is_on_wall()
		if wall_stick_enabled and is_touching_wall:
			# Slowly fall
			velocity.y = 10
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				$JumpSound.play()  # sound for jumping
				if is_on_wall() and velocity.x < 0:
					velocity.x = SPEED * 6
				elif is_on_wall() and velocity.x > 0:
					velocity.x = -SPEED * 6
				else:
					velocity.x = SPEED * 6 if velocity.x < 0 else -SPEED * 6
				wall_stick_enabled = false
				await get_tree().create_timer(0.1).timeout
				wall_stick_enabled = true

	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSound.play()  # sound for jumping

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
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	is_climbing_ladder = true  # Set to true while climbing
	# Additional ladder-specific mechanics can be added here if necessary.

func update_animation():
	# Determine the appropriate animation based on player state
	if is_on_floor():
		if abs(velocity.x) > 0:
			animated_sprite.play("Walk")
		else:
			animated_sprite.play("Idle")
	elif is_climbing_ladder:
		animated_sprite.play("Jumping")
	else:
		if is_on_wall() and wall_stick_enabled:
			animated_sprite.play("WallStick")
		elif velocity.y < 0:
			animated_sprite.play("Jumping")
		else:
			animated_sprite.play("Jumping")

func apply_fall_damage(fall_speed: float):
	var damage = fall_speed * fall_damage_factor
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

func add_treasure(amount: int) -> void:
	score += amount
	update_score_display()  # Update score display

# Update score in the UI
func update_score_display() -> void:
	score_label.text = "Treasure: " + str(score)

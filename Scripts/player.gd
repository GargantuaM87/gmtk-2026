extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var attack_hitbox = $AttackArea/AttackHitBox
@onready var coyote_timer : Timer = $CoyoteTimer


@export var jump_buffer_timer : float = 0.1
@export var coyote_time : float = 0.1
@export var hitbox_time : float = 0.2
@export var attack_cooldown : float = 0.3
@export var wall_jump_horizontal_velocity_time_window : float = 0.0

const WALL_JUMP_HORIZONTAL_VELOCITY_TIME_WINDOW = 0.2
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 350
const WALL_JUMP_HORIZONTAL_VELOCITY = 300

# if the player is ccurently attacking, creates a lock to prevent other animations from override
var can_attack = true
var attacking = false 
var play_jump = true # if jumping is vailable
var jump_buffer : bool = false # jump buffering
var should_horizontal_speed
var debug_flag_0 = false
func on_wall() -> bool:
	return $RightWall.is_colliding() or $LeftWall.is_colliding()
func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("a_button", "d_button")
	if dir:
		if wall_jump_horizontal_velocity_time_window > 0.0:
			wall_jump_horizontal_velocity_time_window -= delta
			velocity.x = should_horizontal_speed
		else:
			velocity.x = dir * SPEED
			if not is_on_floor():
				velocity.x * 0.8
		if dir > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		if wall_jump_horizontal_velocity_time_window > 0.0:
			wall_jump_horizontal_velocity_time_window -= delta
			velocity.x = should_horizontal_speed
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		#Jump Action
	if Input.is_action_just_pressed("space"):
		if play_jump:
			jump()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeut)
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	if !is_on_floor() and !on_wall():
		if(play_jump):
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
	else:
		play_jump = true
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false
		
	# Movement Animation
	if is_on_floor() and !attacking:
		# Necessary animations to play
		if dir == 0:
			sprite.play("default")
		else:
			sprite.play("running")
	# Jumping Animation
	elif !is_on_floor() and !attacking and play_jump:
		sprite.play("jumping")
		if not sprite.animation_finished.is_connected(_on_jump_finished):
			sprite.animation_finished.connect(_on_jump_finished, CONNECT_ONE_SHOT)
	# Attack Animation
	if is_on_floor() and Input.is_action_just_pressed("mouse_left") and can_attack:
		sprite.play("attack")
		velocity.x = 0
		attacking = true
		can_attack = false
		attack_hitbox.disabled = false

		# So this is a timer for attacking
		get_tree().create_timer(attack_cooldown).timeout.connect(_on_attack_finished)
		# Timer for when the box collider will be disabled again
		get_tree().create_timer(hitbox_time).timeout.connect(on_hitbox_finished)
	
	#if debug_flag_0 == true:
	#	debug_flag_0 = false
	#	print(velocity.x)
	move_and_slide()
	
func _on_attack_finished():
	attacking = false
	can_attack = true

func on_hitbox_finished():
	attack_hitbox.disabled = true

func _on_jump_finished():
	sprite.play("in_air")
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY
	if on_wall() and not is_on_floor():
		#debug_flag_0 = true
		wall_jump_horizontal_velocity_time_window = WALL_JUMP_HORIZONTAL_VELOCITY_TIME_WINDOW
		if $LeftWall.is_colliding():
			velocity.x = HORIZONTAL_VELOCITY
			should_horizontal_speed = velocity.x
			sprite.flip_h = false
		else:
			velocity.x = -HORIZONTAL_VELOCITY
			should_horizontal_speed = velocity.x
			sprite.flip_h = true
	play_jump = false

func coyote_timeout() -> void:
	play_jump = false

func on_jump_buffer_timeut() -> void:
	jump_buffer = false

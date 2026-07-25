extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D
@onready var attack_hitbox = $AttackArea/AttackHitBox
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var master_timer: MasterTimer = $"../MasterTimer"

@export var jump_buffer_timer : float = 0.1
@export var coyote_time : float = 0.1
signal interact
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 350

# if the player is ccurently attacking, creates a lock to prevent other animations from override
var attacking = false 
var play_jump = true # if jumping is vailable
var jump_buffer : bool = false # jump buffering
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.008, 0.008, 0.008, 1.0)) # Light gray
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if(play_jump):
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
			#get_tree().create_timer(coyote_time).timeout.connect(coyote_timeout)
	else:
		play_jump = true
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false
	
	
	if Input.is_action_just_pressed("interact"): # e by default pls
		emit_signal("interact")
	#Jump Action
	if Input.is_action_just_pressed("space"):
		if play_jump:
			jump()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeut)
		
	var dir := Input.get_axis("a_button", "d_button")
	
	if dir:
		velocity.x = dir * SPEED
		if dir > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
	if is_on_floor() and Input.is_action_just_pressed("mouse_left"):
		sprite.play("attack")
		velocity = Vector2(0, 0)
		attacking = true
		if sprite.frame == 8 or sprite.frame == 9:
			attack_hitbox.disabled = false
		else:
			attack_hitbox.disabled = true
		if not sprite.animation_finished.is_connected(_on_attack_finished):
			sprite.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)
	move_and_slide()
	
func _on_attack_finished():
	attacking = false
func _on_jump_finished():
	sprite.play("in_air")
	

func jump() -> void:
	velocity.y = JUMP_VELOCITY
	play_jump = false

func coyote_timeout() -> void:
	play_jump = false

func on_jump_buffer_timeut() -> void:
	jump_buffer = false
	
	
func kill() -> void: #Killbox to activate timer effect.
	master_timer.kill()
	
func death(): #When the player actually dies
	print('hi')

extends CharacterBody2D

signal interact

@onready var sprite = $AnimatedSprite2D
@onready var attack_hitbox = $AttackArea/AttackHitBox
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var master_timer: MasterTimer = $"../MasterTimer"
@onready var hit_box : Area2D = $Hitbox
@onready var secondsminus: Label = $Label


@export_group("Player")
@export var jump_buffer_timer : float = 0.1
@export var coyote_time : float = 0.1
@export_group("Atk")
@export var hitbox_time : float = 0.2
@export var attack_cooldown : float = 0.35
@export var dash_time : float = 0.05
@export var movement_lock_time := 0.20
@export_group("Jump Atk")
@export var dash_speed = 200
@export var jump_attack_cooldown : float = 0.5
@export var jump_attack_movement_cooldown : float = 0.03
@export var jump_attacks : float = 1
@export_group("Misc")
@export var wall_jump_horizontal_velocity_time_window : float = 0.0
@onready var atksfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

const WALL_JUMP_HORIZONTAL_VELOCITY_TIME_WINDOW = 0.2
const JUMP_VELOCITY = -420.0 
const SPEED = 300.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 350
const WALL_JUMP_HORIZONTAL_VELOCITY = 300
# Resources
const SLASH_PRELOAD = preload("res://Scenes/sword_slash.tscn")

# if the player is ccurently attacking, creates a lock to prevent other animations from override
var can_attack = true
var attacking = false 
var movement_locked = false
var play_jump = true # if jumping is available
var jump_buffer : bool = false # jump buffering
var should_horizontal_speed
var debug_flag_0 = false
var last_dir = 0 # for saving the last value that direction was in, without storing 0
var slash_time = 0.5
@export var knockback_decay_time: float = 0.3
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_tween: Tween


var is_hitting : bool = false

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
	hit_box.area_entered.connect(on_area_enterted)

func on_wall() -> bool:
	return $RightWall.is_colliding() or $LeftWall.is_colliding()

# Make sure to delegate non-physics processes to 
func _process(delta: float) -> void:
	if last_dir < 0:
		attack_hitbox.scale = Vector2(-1, 1)
	else:
		attack_hitbox.scale = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	if not is_on_floor() and !movement_locked:
		velocity.y += GRAVITY * delta
		if(play_jump):
			if coyote_timer.is_stopped():
				coyote_timer.start(coyote_time)
			#get_tree().create_timer(coyote_time).timeout.connect(coyote_timeout)
	elif is_on_floor() and !movement_locked:
		play_jump = true
		jump_attacks = 1
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false
	
	
	if Input.is_action_just_pressed("interact"): # e by default pls
		emit_signal("interact")
	var dir := Input.get_axis("a_button", "d_button")
	if movement_locked: dir = 0
	if dir:
		if wall_jump_horizontal_velocity_time_window > 0.0:
			wall_jump_horizontal_velocity_time_window -= delta
			velocity.x = should_horizontal_speed
		else:
			velocity.x = dir * SPEED
		# Switching player direction
		if dir > 0:
			sprite.flip_h = false
			last_dir = 1
		elif dir < 0:
			sprite.flip_h = true
			last_dir = -1
	else:
		if wall_jump_horizontal_velocity_time_window > 0.0:
			wall_jump_horizontal_velocity_time_window -= delta
			velocity.x = should_horizontal_speed
		else:
			if !attacking:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		#Jump Action
	if Input.is_action_just_pressed("space"):
		if movement_locked:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeut)
		elif play_jump:
			jump()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeut)
	
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
	velocity += knockback_velocity
	handle_animations(dir)
	


	move_and_slide()

# go over and refactor this code later
# All custom functions go below this comment

func handle_animations(dir : float) -> void:
		# Movement Animation
	if is_on_floor() and !attacking:
		# Necessary animations to play
		if dir == 0:
			sprite.play("default")
		else:
			sprite.play("running")
	# Jumping Animation
	elif !is_on_floor() and !attacking:
		sprite.play("jumping")
		#if not sprite.animation_finished.is_connected(_on_jump_finished):
			#sprite.animation_finished.connect(_on_jump_finished, CONNECT_ONE_SHOT)
	# Attack Animation on ground
	if is_on_floor() and Input.is_action_just_pressed("mouse_left") and can_attack:
		sprite.play("attack")
		atksfx.playSFX("swing_miss")
		spawn_slash()
		velocity.x = 0
		attacking = true
		movement_locked = true
		can_attack = false
		attack_hitbox.disabled = false
		attack_timers()
	# Attack Animation in the air
	if !is_on_floor() and Input.is_action_just_pressed("mouse_left") and jump_attacks > 0:
		sprite.play("jump_attack")
		atksfx.playSFX("air_miss")
		if last_dir == null:
			last_dir = 1
			
			
		velocity.y = 0
		velocity.x += last_dir * dash_speed
		attacking = true
		movement_locked = true
		can_attack = false
		jump_attacks = 0
		attack_hitbox.disabled = false
		if not sprite.animation_finished.is_connected(attack_jump_timers):
			sprite.animation_finished.connect(attack_jump_timers, CONNECT_ONE_SHOT)

func spawn_slash() -> void:
	var sword_slash_var : Node2D = SLASH_PRELOAD.instantiate()
	var anim_p : AnimationPlayer = sword_slash_var.get_node("AnimationPlayer")
	#var slash_sprite : Sprite2D = sword_slash_var.get_node("Sprite2D")

	sword_slash_var.global_position = global_position
	anim_p.speed_scale = anim_p.get_animation("slash").length / slash_time
	#slash_sprite.flip_h = last_dir > 0
	get_parent().add_child(sword_slash_var)


func attack_timers() -> void:
	# So this is a timer for attacking
	get_tree().create_timer(attack_cooldown).timeout.connect(_on_attack_finished)
	# Timer for when the box collider will be disabled again
	get_tree().create_timer(hitbox_time).timeout.connect(on_hitbox_finished)
	# Timer before player is allowed to move again
	get_tree().create_timer(movement_lock_time).timeout.connect(_unlock_movement)
	
	
func attack_jump_timers() -> void:
	# So this is a timer for attacking
	get_tree().create_timer(jump_attack_movement_cooldown).timeout.connect(_on_attack_finished)
	# Timer for when the box collider will be disabled again
	get_tree().create_timer(hitbox_time).timeout.connect(on_hitbox_finished)
	get_tree().create_timer(movement_lock_time).timeout.connect(_unlock_movement)

func _unlock_movement():
	movement_locked = false

	if jump_buffer and is_on_floor():
		jump()
		jump_buffer = false
	
func _on_attack_finished():
	attacking = false
	movement_locked = false
	can_attack = true

func on_hitbox_finished():
	attack_hitbox.disabled = true

func _on_jump_finished():
	sprite.play("in_air")

func on_area_enterted(node : Area2D) -> void:
	if node.owner.is_in_group("enemies"):
		deal_damage(node)
		
		apply_knockback(Vector2(0,-1), 50)
		var floating = preload("res://Scenes/text_handler.tscn").instantiate()
		get_tree().current_scene.add_child(floating)
		dmg(5)
		floating.show_text("-5s", position - Vector2(0, 65))
		sfx("dmg")

func deal_damage(node : Area2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)

func set_shader_blink_intensity(new_value : float):
	sprite.material.set_shader_parameter("blink_intensity", new_value)

func dmg(val: float):
	master_timer.damage(val)
	
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
	print("Jump velocity:", velocity.y)
	velocity.y = JUMP_VELOCITY
func apply_knockback(direction: Vector2, strength: float) -> void:
	knockback_velocity = direction.normalized() * strength

	if knockback_tween and knockback_tween.is_valid():
		knockback_tween.kill()

	knockback_tween = create_tween()
	knockback_tween.tween_property(self, "knockback_velocity", Vector2.ZERO, knockback_decay_time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	
func coyote_timeout() -> void:
	play_jump = false

func on_jump_buffer_timeut() -> void:
	jump_buffer = false
	
	
func kill() -> void: #Killbox to activate timer effect.
	master_timer.kill()
	
func death(): #When the player actually dies
	print('hi')

func sfx(name):
	atksfx.playSFX(name)
	

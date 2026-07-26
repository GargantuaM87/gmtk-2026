class_name Enemy extends CharacterBody2D


@onready var hitbox : Area2D = $Hurtbox1
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var timer : Timer = $Timer
@onready var raycast : RayCast2D = $AnimatedSprite2D/Raycast2D

@export var health : float = 4
@export var chase_range : float = 250
@export var attack_range : float = 25

enum States { IDLE, ATTACKING, MOVING }

const SPEED = 200
const JUMP_VELOCITY = -300
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 299

var last_position = Vector2(0,0)
var offset_from_player : Vector2 = Vector2(50, 50)
var state : States = States.IDLE
var target : Vector2 
var distance : float

var player : CharacterBody2D = null

func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")
	hitbox.area_entered.connect(on_hitbox_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity.y = 0
	target = player.global_position + offset_from_player
	distance = global_position.distance_to(target)
	calc_state()
	# IDLE STATE	
	if state == States.IDLE:
		velocity.x = 0
		sprite.play("idle")
	# MOVEMENT STATE
	if state == States.MOVING:
		var dir = 0
		if distance > 2.5:
			dir = global_position.direction_to(target)
			sprite.play("jump")
			if dir.x > 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			velocity.x = dir.x * SPEED
		else:
			velocity.x = 0
	# ATTACKING STATE
	if state == States.ATTACKING:
		sprite.play("attack")
		
	move_and_slide()
	

func on_hitbox_entered(node : Node2D) -> void:
	if node.owner.is_in_group("player"):
		take_damage()
	
func take_damage():
	health -= 1
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)
	if health <= 0:
		player = get_tree().get_first_node_in_group("player")
		player.dmg(-10)
		queue_free()

func calc_state() -> void:
	if distance <= chase_range and distance > attack_range:
		state = States.MOVING
	elif distance > chase_range:
		state = States.IDLE
	elif distance <= attack_range:
		state = States.ATTACKING
	

func set_shader_blink_intensity(new_value : float):
	sprite.material.set_shader_parameter("blink_intensity", new_value)

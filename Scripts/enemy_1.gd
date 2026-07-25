extends CharacterBody2D

@onready var hitbox : Area2D = $Node2D/Hurtbox1

@export var health : float = 2

const SPEED = 300.0
const JUMP_VELOCITY = -300
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 400

var last_position = Vector2(0,0)

func _ready() -> void:
	hitbox.area_entered.connect(on_hitbox_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity.y = 0
	var dir = 0
	if %Player.position.x > position.x:
		dir = 1
	else:
		dir = -1
	velocity.x = dir * HORIZONTAL_VELOCITY
	move_and_slide()
	if (position == last_position):
		velocity.y = JUMP_VELOCITY
		move_and_slide()
	last_position = position

func on_hitbox_entered(node : Area2D) -> void: 
	if node.owner.is_in_group("player"):
		take_damage()
	
func take_damage():
	health -= 1
	if health <= 0:
		queue_free()

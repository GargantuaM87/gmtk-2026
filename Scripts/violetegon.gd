extends CharacterBody2D

@onready var hitbox : Area2D = $Hurtbox1
@onready var detect_area : Area2D = $DetectArea
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var attack_box : Area2D = $Area2D

@export var speed := 200.0
@export var orbit_speed := 3.0
@export var orbit_radius := 150.0
@export var attack_range := 180.0
@export var attack_cooldown := 1.5
@export var health : float = 4

enum State {
	IDLE,
	MOVEMENT,
	ATTACKING
}

var player: Node2D
var state: State = State.IDLE
var orbit_angle := 0.0
var attack_timer := 0.0
var hitbox_time := 0.3

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	hitbox.area_entered.connect(on_hitbox_entered)

func _physics_process(delta):
	if player == null:
		return

	attack_timer -= delta

	match state:
		State.IDLE:
			idle_state()

		State.MOVEMENT:
			movement_state(delta)

		State.ATTACKING:
			attacking_state()

	move_and_slide()

func idle_state():
	velocity = Vector2.ZERO
	sprite.play("idle")

	if can_see_player():
		state = State.MOVEMENT

func movement_state(delta):

	if !can_see_player():
		state = State.IDLE
		return

	var distance = global_position.distance_to(player.global_position)
	sprite.play("idle")

	if distance <= attack_range:
		state = State.ATTACKING
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

	if direction.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func attacking_state():

	if !can_see_player():
		state = State.IDLE
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > attack_range:
		state = State.MOVEMENT
		return

	orbit_angle += orbit_speed * get_physics_process_delta_time()

	var target = player.global_position + Vector2(
		cos(orbit_angle),
		sin(orbit_angle)
	) * orbit_radius

	velocity = (target - global_position).normalized() * speed

	if attack_timer <= 0:
		attack()
		attack_timer = attack_cooldown

func can_see_player() -> bool:
	var direction = player.global_position - global_position

	raycast.target_position = direction
	raycast.force_raycast_update()

	if !raycast.is_colliding():
		return false

	return raycast.get_collider() == player


func attack() -> void:
	sprite.play("attack")
	velocity = Vector2.ZERO
	attack_box.disabled = false
	get_tree().create_timer(hitbox_time).timeout.connect(on_hitbox_finished)

func on_hitbox_entered(node : Node2D) -> void: 
	if node.owner.is_in_group("player"):
		take_damage()
	
func take_damage():
	health -= 1
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_blink_intensity, 1.0, 0.0, 0.5)
	if health <= 0:
		queue_free()

func set_shader_blink_intensity(new_value : float):
	sprite.material.set_shader_parameter("blink_intensity", new_value)

func on_hitbox_finished():
	attack_box.disabled = true

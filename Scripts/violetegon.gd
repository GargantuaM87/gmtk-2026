extends CharacterBody2D

@onready var hitbox : Area2D = $Hurtbox1
@onready var detect_area : Area2D = $DetectArea
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 200.0
@export var orbit_speed := 3.0
@export var orbit_radius := 150.0
@export var attack_range := 180.0
@export var attack_cooldown := 1.5
@export var health : float = 4

var player: Node2D
var orbit_angle := 0.0
var attack_timer := 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("enemies")
	hitbox.area_entered.connect(on_hitbox_entered)

func _physics_process(delta):
	if player == null:
		return

	attack_timer -= delta

	var distance = global_position.distance_to(player.global_position)

	if distance > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		orbit_angle += orbit_speed * delta

		var target_position = player.global_position + Vector2(
			cos(orbit_angle),
			sin(orbit_angle)
		) * orbit_radius

		var direction = (target_position - global_position).normalized()
		velocity = direction * speed

		if attack_timer <= 0:
			attack_timer = attack_cooldown

	move_and_slide()

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

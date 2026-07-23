extends CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 350
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("space"):
			velocity.y = JUMP_VELOCITY
	var dir = 0
	if Input.is_action_pressed("d_button"):
		animated_sprite_2d.play("running")
		dir += 1
	if Input.is_action_pressed("a_button"):
		animated_sprite_2d.play("running")
		dir -= 1
	if !Input.is_action_pressed("a_button") and !Input.is_action_pressed("d_button"):
		animated_sprite_2d.play("default")
	if Input.is_action_just_pressed("debug1"):
		var floating = preload("res://Scenes/text_handler.tscn").instantiate()
		get_tree().current_scene.add_child(floating)
		floating.show_text("+10s", position - Vector2(0, 65))
	if dir == 1:
		$Node2D.scale.x = 1
	elif dir == -1:
		$Node2D.scale.x = -1
	if Input.is_action_just_pressed("mouse_left"):
		%Sword.hit_horizontal()
	velocity.x = dir * HORIZONTAL_VELOCITY
	move_and_slide()
	

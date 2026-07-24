extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 200
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("space"):
			velocity.y = JUMP_VELOCITY
	var dir = 0
	if Input.is_action_pressed("d_button"):
		dir += 1
	if Input.is_action_pressed("a_button"):
		dir -= 1
	if Input.is_action_just_pressed("mouse_left"):
		$Sword.hit()
	velocity.x = dir * HORIZONTAL_VELOCITY
	move_and_slide()
	

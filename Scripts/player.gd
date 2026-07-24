extends CharacterBody2D
@onready var sprite2D = $Node2D/AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1000
const HORIZONTAL_VELOCITY = 350
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	#Jump Action
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Debug Action???
	if Input.is_action_just_pressed("debug1"):
		var floating = preload("res://Scenes/text_handler.tscn").instantiate()
		get_tree().current_scene.add_child(floating)
		floating.show_text("+10s", position - Vector2(0, 65))
		
	var dir := Input.get_axis("a_button", "d_button")
	
	if dir:
		velocity.x = dir * SPEED
		if dir > 0:
			sprite2D.flip_h = false
		else:
			sprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor():
		# Necessary animations to play
		if dir == 0:
			sprite2D.play("default")
		else:
			sprite2D.play("running")
	else:
		sprite2D.play("jumping")	
	
	if Input.is_action_just_pressed("mouse_left"):
		pass
	move_and_slide()
	

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.set_disabled(true)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
func hit():
	print("hit")
	$Area2D/CollisionShape2D.set_disabled(false)
	$Timer.start()


func _on_timer_timeout() -> void:
	$Area2D/CollisionShape2D.set_disabled(true)

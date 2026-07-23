extends Node2D
const ATTACK_COOLDOWN = 0.7
var time_since_last_hit = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.set_disabled(true)

func _process(delta: float) -> void:
	time_since_last_hit += delta
func hit_horizontal():
	if time_since_last_hit < ATTACK_COOLDOWN:
		return
	print("hit")
	time_since_last_hit = 0.06
	$Area2D/CollisionShape2D.set_disabled(false)
	$Timer.start()


func _on_timer_timeout() -> void:
	$Area2D/CollisionShape2D.set_disabled(true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("enemy_hit"):
		area.enemy_hit()

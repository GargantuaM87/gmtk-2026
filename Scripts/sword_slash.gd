extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	look_at(get_global_mouse_position())
	animation_player.play("slash")

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "slash":
		queue_free()

func _on_area_2d_body_entered(body : Node2D) -> void:
	if body.owner.is_in_group("enemies"):
		body.take_damage()

extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var player
func _ready():
	add_to_group("player")
	look_at(get_global_mouse_position())
	animation_player.play("slash")
	player = get_tree().get_first_node_in_group("player")
	

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "slash":
		queue_free()

extends Area2D

signal player_attacked

func area_entered(_node: Node2D):
	emit_signal("player_attacked")

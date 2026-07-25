extends Area2D
signal activated
var bodies_in_hitbox: Array = []
@onready var player: CharacterBody2D = $"../Player"

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var started:bool = false
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		


func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		print("kitbox in")
		bodies_in_hitbox.append(body)
		player.kill()
		
		
		

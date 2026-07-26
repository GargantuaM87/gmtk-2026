extends Area2D
@onready var label: Label = $"../Label"
signal activated
var bodies_in_hitbox: Array = []
var player = null
@onready var collision_shape_2d: Area2D = $"."
var started:bool = false
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	label.hide()
	player.interact.connect(_interact)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _interact():
	for bodies in bodies_in_hitbox:
		print(bodies)
		if bodies.is_in_group("player") and !started:
			emit_signal("activated")
			print("interacted")
		
	
	
func _on_body_exited(body: Node):
	if body in bodies_in_hitbox and body.is_in_group("player"):
		bodies_in_hitbox.erase(body)
		label.hide()

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"):
		if !started:
			label.show()
		bodies_in_hitbox.append(body)
func startGame():
	started = true
	label.hide()

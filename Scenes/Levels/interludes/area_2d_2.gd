extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
var started: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var bgm: AudioStreamPlayer = %BGM
@onready var bgm2: AudioStreamPlayer = %BGM2
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !started:
		started = true
		get_tree().get_first_node_in_group("bgm_main").stop()
		get_tree().get_first_node_in_group("bgm_secondary").stop()
		
		get_tree().get_first_node_in_group("timer").stop()

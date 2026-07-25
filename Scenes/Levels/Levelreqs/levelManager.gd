extends Node2D
var rng = RandomNumberGenerator.new()
@export var scenes: Array[PackedScene]
@export var rooms: int
@onready var room_manager: Marker2D = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
var loaded: Array[Node2D] = []

func loadscene(target_exit: Vector2):
	var rand = rng.randi_range(0, scenes.size()-1)
	var room = scenes[rand].instantiate()
	loaded.append(room)
	add_child(room)
	
	var new_entrance: Vector2 = room.get_node("EntryPoint").global_position
	# Calculate offset and shift the new room
	var offset: Vector2 = target_exit - new_entrance
	room.global_position += offset
	
	
func loadRooms():
	loadscene(room_manager.global_position)
	for i in (rooms - 1):
		loadscene(loaded[-1].get_node("ExitPoint").global_position)
		
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

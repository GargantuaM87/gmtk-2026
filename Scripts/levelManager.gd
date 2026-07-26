extends Node2D
var rng = RandomNumberGenerator.new()
@export var scenes: Array[lvlbundle]
@onready var room_manager: Marker2D = $"."
var loaded: Array[Node2D] = []
var loadednums: Array[int] = []
var startpoint = null
func _ready() -> void:
	startpoint = room_manager.global_position
	pass
func genint(lvl: lvlbundle) -> int:
	return rng.randi_range(0, lvl.roomarray.size() - 1)
func loadscene(lvl: lvlbundle, target_exit: Vector2):
	var rand = 0
	while true:
		rand = genint(lvl)
		print(rand)
		if loadednums.size() == lvl.rooms:
			print("flushedloadednums")
			loadednums.clear()
		if rand not in loadednums:
			loadednums.append(rand)
			break

	var room = lvl.roomarray[rand].instantiate()
	loaded.append(room)
	add_child(room)

	var new_entrance: Vector2 = room.get_node("EntryPoint").global_position
	var offset: Vector2 = target_exit - new_entrance
	room.global_position += offset
	await get_tree().process_frame

func loadBundle(lvl: lvlbundle):
	loadednums.clear()
	await loadscene(lvl, startpoint)
	for i in range(lvl.rooms - 1):
		await loadscene(lvl, loaded[-1].get_node("ExitPoint").global_position)
	startpoint = loaded[-1].get_node("ExitPoint").global_position

func loadRooms():
	for bundle in scenes:
		await loadBundle(bundle)
func _process(delta: float) -> void:
	pass

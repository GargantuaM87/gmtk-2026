extends Node2D
@onready var label: Label = $Label
@onready var area_2d: Area2D = $Area2D
@onready var bgm: AudioStreamPlayer = $"../BGM"
@onready var master_timer: MasterTimer = $"../MasterTimer"
@onready var roomgen: Node2D = $"../RoomManager"
@onready var room_timer: Label = $"../RoomTimer"
@onready var introseq: Label = $"../introseq"
@onready var door: Node2D = $"../Door"
@onready var intro_sfx: AudioStreamPlayer = $"../IntroSFX"


@export var text: TextEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_timer.get_child(0).get_child(0).hide()
	area_2d.activated.connect(startGame)
	room_timer.hide()
	introseq.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startGame():
	area_2d.startGame()
	bgm.play()
	intro_sfx.stop()
	master_timer.start()
	master_timer.get_child(0).get_child(0).show()
	roomgen.loadRooms()
	room_timer.show()
	introseq.hide()
	door.open()
func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

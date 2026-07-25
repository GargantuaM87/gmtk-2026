extends Node2D
@onready var label: Label = $Label
@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"
@onready var master_timer: MasterTimer = $"../MasterTimer"


@export var text: TextEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_timer.get_child(0).get_child(0).hide()
	area_2d.activated.connect(startGame)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startGame():
	area_2d.startGame()
	audio_stream_player.play()
	master_timer.start()
	master_timer.get_child(0).get_child(0).show()
func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

extends Node2D
@onready var label: Label = $Label
@export var text: TextEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_activated() -> void:
	get_parent().open()

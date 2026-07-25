extends RichTextLabel

@export var typing_speed: float = 20.0
var time_passed: float = 0.0

func _ready() -> void:
	visible_characters = 0
	time_passed = 0.0

func _process(delta: float) -> void:
	if visible_characters < get_total_character_count():
		time_passed += delta
		visible_characters = int(time_passed * typing_speed)

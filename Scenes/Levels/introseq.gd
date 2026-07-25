extends Label

@export var typing_speed: float = 0.02 # Time in seconds per character

func _ready() -> void:
	play_typewriter("-$  ./detonate.sh
> detonation sequence activated
> FATAL ERR: OVERRIDE PROTECTION 
STILL IN PLACE

> ERR : REQUIRES USER INPUT...")

func play_typewriter(new_text: String) -> void:
	text = new_text
	visible_characters = 0
	
	var total_chars = text.length()
	var tween = create_tween()
	tween.tween_property(self, "visible_characters", total_chars, total_chars * typing_speed)

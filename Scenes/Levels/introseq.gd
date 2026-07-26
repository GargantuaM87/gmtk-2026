extends Label

@export var typing_speed: float = 0.02 # Time in seconds per character
@onready var introseq: Label = $"."

func _ready() -> void:
	play_typewriter("-$  /sub19/failsafes/detonate.exe
> User Authenticated. Sequence active
> FATAL ERR: OVERRIDE PROTECTION 
IN PLACE

> ERR : REQUIRES USER INPUT...")
	while true:

		introseq.text = introseq.text.left(-3)
		await get_tree().create_timer(0.75).timeout


		introseq.text += "."
		await get_tree().create_timer(0.75).timeout

		introseq.text += "."
		await get_tree().create_timer(0.75).timeout

		introseq.text += "."
		await get_tree().create_timer(0.75).timeout
		
	

func play_typewriter(new_text: String) -> void:
	text = new_text
	visible_characters = 0
	
	var total_chars = text.length()
	var tween = create_tween()
	tween.tween_property(self, "visible_characters", total_chars, total_chars * typing_speed)

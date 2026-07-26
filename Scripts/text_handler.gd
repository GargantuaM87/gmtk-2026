extends Node2D

@onready var label = $Label
var rng = RandomNumberGenerator.new()


func show_text(text: String, start_pos: Vector2):
	if text.contains("+"):
		label.add_theme_color_override("font_color", Color.GREEN)
	elif text.contains("-"):
		label.add_theme_color_override("font_color", Color.RED)
	else:
		label.add_theme_color_override("font_color", Color.GHOST_WHITE)
	label.text = text
	position = start_pos
	
	modulate.a = 1.0

	var tween = create_tween()
	tween.set_parallel()

	tween.tween_property(self, "position:y", position.y - 40, 0.8)
	tween.tween_property(self, "position:x", position.x - (rng.randf_range(-20, 20)), 0.8)
	tween.tween_property(self, "modulate:a", 0.0, 0.8)

	tween.chain().tween_callback(queue_free)

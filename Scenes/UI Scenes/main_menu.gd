extends Control

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var fade_timer: Timer = $ButtonManager/Fade/fade_timer
@onready var fade_anim: AnimationPlayer = $ButtonManager/Fade/FadeAnim
@onready var fade: ColorRect = $ButtonManager/Fade

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_pressed() -> void:
	button_type = "start"
	fade.show()
	fade_timer.start()
	fade_anim.play("Fin")


func _on_options_pressed() -> void:
	button_type = "options"
	fade.show()
	fade_timer.start()
	fade_anim.play("Fin")


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		
		get_tree().change_scene_to_file("res://Scenes/Levels/intro_room.tscn")

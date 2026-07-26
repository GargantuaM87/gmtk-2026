extends Node2D
@onready var bottom: CollisionShape2D = $Hitbox/bottom
@onready var top: CollisionShape2D = $Hitbox/top

@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D

# Called when the node enters the scene tree for the first time.
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func open():
	var tween = get_tree().create_tween()
	tween.tween_property(bottom, "position:y", -200, 0.25)
	tween.tween_property(top, "position:y", 200, 0.25)
	light_occluder_2d.hide()
	anim.play("open")
	sfx.play()

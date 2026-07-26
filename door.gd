extends Node2D
@onready var bottom: CollisionShape2D = $Hitbox/bottom
@onready var top: CollisionShape2D = $Hitbox/top
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var light_occluder_2d: LightOccluder2D = $AnimatedSprite2D/LightOccluder2D

signal openDoor
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	openDoor.connect(open)

func open():
	var tween = get_tree().create_tween()
	tween.tween_property(bottom, "position:y", -200, 0.25)
	tween.tween_property(top, "position:y", 200, 0.25)
	light_occluder_2d.hide()
	anim.play("open")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node2D
@onready var bottom: CollisionShape2D = $Hitbox/bottom
@onready var top: CollisionShape2D = $Hitbox/top
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var light_occluder_2d: LightOccluder2D = $AnimatedSprite2D/LightOccluder2D
@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var label: Label = $Label
@export var cost: int
signal openDoor
var isopenablebyfight = true
var openable: bool = true
var enemybox: Area2D
var was_cleared: bool = false

func _ready() -> void:
	enemybox = $enemybox
	if enemybox:
		anim.play("locked")
		label.text = "$" + str(cost) + "s"
		openable = false
		# let physics settle a frame before the first poll
		await get_tree().physics_frame
		await get_tree().physics_frame
		_poll_enemies()
	else:
		label.text = "open"

func _physics_process(delta: float) -> void:
	if enemybox and not was_cleared:
		_poll_enemies()
var has_seen_enemies: bool = false

func _poll_enemies() -> void:
	var count := 0
	for body in enemybox.get_overlapping_bodies():
		if is_instance_valid(body) and body.is_in_group("enemies"):
			count += 1
	if count > 0:
		has_seen_enemies = true
	if count == 0 and has_seen_enemies:
		_on_all_enemies_cleared()

func _on_all_enemies_cleared() -> void:
	if was_cleared:
		return
	was_cleared = true
	anim.play("default")
	label.text = "[paid]"
	openable = true
	isopenablebyfight = true

func open():
	if !openable:
		var player = get_tree().get_first_node_in_group("player")
		player.dmg(cost)
		pass
	var tween = get_tree().create_tween()
	tween.tween_property(bottom, "position:y", -200, 0.25)
	tween.tween_property(top, "position:y", 200, 0.25)
	light_occluder_2d.hide()
	anim.play("open")
	sfx.play()

func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

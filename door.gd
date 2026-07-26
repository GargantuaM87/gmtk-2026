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
var enemybox = get_node_or_null("$enemybox")
# Called when the node enters the scene tree for the first time.
var bodies_inside: Array[Node] = []
var openable: bool = true
func _ready() -> void:
    if enemybox:
        enemybox.body_entered.connect(_on_body_entered)
        enemybox.body_exited.connect(_on_body_exited)
        anim.play("locked")
        label.text = "$" + str(cost) + "s"
        openable = false
    else:
        pass

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("enemies"):
        bodies_inside.append(body)

func _on_body_exited(body: Node) -> void:
    if body.is_in_group("enemies") and bodies_inside.has(body):
        bodies_inside.erase(body)
        if bodies_inside.is_empty():
            _on_all_enemies_cleared()

func _on_all_enemies_cleared() -> void:
    anim.play("default")
    label.text = "[paid]"
    openable = true
    isopenablebyfight = true
    
    # or whatever should happen — open the door, emit a signal, etc.
func open():
    if !openable:
        var player = get_tree().get_first_node_in_group("player")
        player.dmg(cost)
        pass
        # Deduct time
    var tween = get_tree().create_tween()
    tween.tween_property(bottom, "position:y", -200, 0.25)
    tween.tween_property(top, "position:y", 200, 0.25)
    light_occluder_2d.hide()
    anim.play("open")
    sfx.play()
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

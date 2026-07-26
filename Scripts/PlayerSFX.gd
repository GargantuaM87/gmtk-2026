extends AudioStreamPlayer2D

@export var audio_streams: Array[AudioStream]
@export var indexes: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func playSFXindex(i):
	self.stream = audio_streams.get(i)
	play()
func playSFX(name):
	for i in indexes.size():
		if indexes[i] == name:
			self.stream = audio_streams.get(i)
			play()
	

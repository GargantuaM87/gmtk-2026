extends Node
class_name MasterTimer

@export var time_amount = 600.0
@onready var label : Label = $CanvasLayer/ClockTime

var time = time_amount
var stopped = false

func _process(delta: float) -> void:
	if stopped:
		return
	time -= delta
	update_stopwatch_label()

func time_to_string() -> String:
	var msec = fmod(time, 1) * 100
	var sec = fmod(time, 60)
	var min = time / 60
	# Formatting time
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [min, sec, msec]
	return actual_string

func update_stopwatch_label():
	label.text = time_to_string()

func update_time(new_time : float):
	time = new_time

func increment_time(new_time : float):
	time -= new_time

func reset():
	time = 60.0	


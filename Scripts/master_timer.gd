extends Node
class_name MasterTimer

@export var time_amount = 180.0
@onready var label : Label = $CanvasLayer/ClockTime
@export var killtimescale = 50.0
@export var timescale = 1.0
@onready var room_timer: Label = $"../RoomTimer"


var time = time_amount
var iskilling = false
var stopped = true

var rtscale = timescale
func _process(delta: float) -> void:
	if stopped:
		return
	time -= (delta * rtscale)
	if time < 180:
		label.add_theme_color_override("font_color", Color.RED)
	if time < 60:
		label.add_theme_color_override("font_color", Color.DARK_RED)
	if time < 0:
		time = 0
		stop()
		get_tree().reload_current_scene()
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
	var text = time_to_string()
	label.text = text
	room_timer.text = text

func update_time(new_time : float):
	time = new_time

func increment_time(new_time : float):
	time += new_time

func reset():
	time = 60.0	
func start():
	stopped = false
func stop():
	stopped = true

func kill():
	print("killing player")
	rtscale = killtimescale
func damage(val: float):
	time -= val

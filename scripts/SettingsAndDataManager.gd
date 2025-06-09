extends Node

#enum OSmode_enum {windows, mac}
var OSmode := &"windows"

var saved_def_color : Color
var saved_swatches : Array[Color]

var resentest_document : DocumentClass

func _ready() -> void:
	match OS.get_name():
		"Windows":
			OSmode = &"windows"
		"macOS":
			OSmode = &"mac"
		_:
			OSmode = &"windows"
			

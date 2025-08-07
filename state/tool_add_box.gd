extends State
class_name tool_add_box

@onready var box_holder: Node2D = $"../../papper/boxHolder"
var default_color = Color.DARK_BLUE

func unhandled_input(event):
	if event.is_action_pressed("LMB"):
		instantiate_box()

func instantiate_box():
	var box = preload("uid://wfnqhd3r5fxx").instantiate()
	box.position = $"../../papper".get_global_mouse_position() - box.size/2
	box.set_color(default_color)
	box_holder.add_child(box)

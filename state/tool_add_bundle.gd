class_name ToolAddBundle extends State


@onready var bundle_holder: Node2D = $"../../papper/bundleHolder"

var default_color = Color.DARK_BLUE

func unhandled_input(event):
	if event.is_action_pressed("LMB"):
		for b in bundle_holder.get_children():
			if b.mouse_inside:
				return
		var bundle = preload("uid://bhwvnws1rjko1").instantiate()
		bundle.position = $"../../papper".get_global_mouse_position() - bundle.get_node("Panel").size/2
		bundle_holder.add_child(bundle)
		bundle.set_color(default_color)

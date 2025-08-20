extends Control
class_name SelectionActions

@onready var selection_system: Control = $".."


func _input(event: InputEvent) -> void:
	var hovered_control = get_viewport().gui_get_hovered_control()
	print("sel actions hov_con: ", hovered_control)
	if hovered_control:
		if hovered_belong_selected(hovered_control): # in selection_system.selected_items:
			print("hov_con is selected")


func get_selected_boxes() -> Array:
	return selection_system.selected_items.filter(func(i): return i is BoxClass)

func get_selected_bundles() -> Array:
	return selection_system.selected_items.filter(func(i): return i is BundleClass)

func hovered_belong_selected(hovered): ###BLEEHHH
	var node = hovered
	while node not in selection_system.selected_items:
		node = node.get_parent()
		if node == $"../../../papper":
			return false
	return true

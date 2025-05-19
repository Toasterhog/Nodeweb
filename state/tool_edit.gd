extends State
class_name tool_edit

@onready var box_holder: Node2D = $"../../papper/boxHolder"
#
#func enter():
	#super.enter()
	#for child in box_holder.get_children():
		#if child is Panel:
			#var te = child.get_node("VBoxContainer/TextEdit") as TextEdit
			#var le = child.get_node("VBoxContainer/LineEdit") as TextEdit
			#le.mouse_filter = Control.MOUSE_FILTER_PASS
			#te.mouse_filter = Control.MOUSE_FILTER_PASS
	#
#func exit():
	#for child in box_holder.get_children():
		#if child is Panel:
			#var te = child.get_node("VBoxContainer/TextEdit") as TextEdit
			#var le = child.get_node("VBoxContainer/LineEdit") as TextEdit
			#le.mouse_filter = Control.MOUSE_FILTER_IGNORE
			#te.mouse_filter = Control.MOUSE_FILTER_IGNORE
#
#func update(delta : float):
	#pass
#
#func input(event: InputEvent) -> void:
	#pass
#
#func unhandled_input(event: InputEvent) -> void:
	#pass

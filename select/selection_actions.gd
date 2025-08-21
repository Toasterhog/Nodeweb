extends Control
class_name SelectionActions

@onready var selection_system: SelectionSystem = $".."
var miaos : bool = false ##mouse in any of selected

func set_miaos(b : bool):
	miaos = b


func _input(event: InputEvent) -> void:
	if is_draging or miaos:
		drag_input(event)
	if not miaos: return
	show_notes(event)

var is_draging : bool = false

func drag_input(e : InputEvent):
	#start/stop drag
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_LEFT or e.button_index == MOUSE_BUTTON_RIGHT:
			if e.pressed: #if mouse press -> draging
				is_draging = true
			elif not e.pressed:  #if mouse release -> not draging and flowing
				is_draging = false
				#set boxes flowing
				for i : SelectableItem in get_selected_boxes():
						i.scriptowner.is_flowing = true
						i.scriptowner.set_process(true)
	#move position
	elif is_draging and e is InputEventMouseMotion: # mouse motion -> move items by mouse.relative, and if box do extra
		for i : SelectableItem in selection_system.selected_items:
			var base = i.scriptowner
			base.global_position += e.relative
			if base is BoxClass:
				base.middlepos = global_position + base.size/2
				base.moved.emit()


func show_notes(e : InputEvent):
	if e is InputEventMouseButton and e.pressed and ((e.button_index == MOUSE_BUTTON_MASK_RIGHT \
	and e.double_click) or Input.is_key_pressed(KEY_META)):
		for b : SelectableItem in get_selected_boxes():
			if b.scriptowner.get_node("MarginContainer/VBoxContainer/HSeparator").visible ==\
			 get_selected_boxes()[0].scriptowner.get_node("MarginContainer/VBoxContainer/HSeparator").visible:
				b.scriptowner.show_notes()
		


func get_selected_boxes() -> Array:
	return selection_system.selected_items.filter(func(i): return i.scriptowner is BoxClass)

func get_selected_bundles() -> Array:
	return selection_system.selected_items.filter(func(i): return i.scriptowner is BundleClass)

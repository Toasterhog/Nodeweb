extends Control
class_name SelectionActions

@onready var selection_system: SelectionSystem = $".."
@onready var state_machine: Node = $"../../../state_machine_tools"
@onready var selection_copy_paste: Control = $"../SelectionCopyPaste"

var miaos : bool = false ##mouse in any of selected
var is_draging : bool = false

func set_miaos(b : bool):
	miaos = b
	delete_indicator_toggle(b)

func get_selected_boxes() -> Array:
	return selection_system.selected_items.filter(func(i): return i.scriptowner is BoxClass)
func get_selected_bundles() -> Array:
	return selection_system.selected_items.filter(func(i): return i.scriptowner is BundleClass)


func _input(event: InputEvent) -> void:
	if not selection_system.selected_items: return #no input if there is no selection
	if is_draging or miaos:
		drag_input(event)
	if miaos: 
		show_notes_input(event)
		color_input(event)
		delete_input(event)
	selection_copy_paste.cp_input(event)



func drag_input(e : InputEvent):
	var papper_mouse_pos = $"../../../papper".get_global_mouse_position() #mouse pos on papper canvas, var bc used in many loops
	#start/stop drag
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_LEFT or e.button_index == MOUSE_BUTTON_RIGHT:
			if e.pressed: #if mouse press -> draging
				is_draging = true
				for i : SelectableItem in selection_system.selected_items: #set offset pos all items
					i.drag_offset_mouse =  i.scriptowner.global_position - papper_mouse_pos
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
			base.global_position = papper_mouse_pos + i.drag_offset_mouse # set pos using offset
			if base is BoxClass:
				base.middlepos = base.global_position + base.size/2
				base.moved.emit()

func show_notes_input(e : InputEvent):
	if e is InputEventMouseButton and e.pressed and ((e.button_index == MOUSE_BUTTON_MASK_RIGHT \
	and e.double_click) or Input.is_key_pressed(KEY_META)):
		var not_visible :bool = not get_selected_boxes()[2].scriptowner.get_node("MarginContainer/VBoxContainer/HSeparator").visible
		for b : SelectableItem in get_selected_boxes():
			var base = b.scriptowner
			base.get_node("MarginContainer/VBoxContainer/TextEdit").visible = not_visible
			base.get_node("MarginContainer/VBoxContainer/HSeparator").visible = not_visible
			base.update_vbc_and_panel_size()
			#get_viewport().set_input_as_handled() #notice no doifferance

func color_input(e : InputEvent):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and state_machine.current_state.name == "ToolColor": 
		var col = state_machine.get_node("tool_add_box").default_color
		for i in selection_system.selected_items:
			i.scriptowner.set_color(col)

func delete_input(e : InputEvent):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and state_machine.current_state.name == "tool_delete": 
		for i in selection_system.selected_items:
			i.scriptowner.delete_self()

func delete_indicator_toggle(mouse_entr :bool):
	if state_machine.current_state.name == "tool_delete":
		if mouse_entr:
			var color_delete_indicate = Color(0.9, 0.1, 0.1, 1)
			for b in get_selected_boxes():
				if not b.scriptowner.mouse_inside:
					b.scriptowner.color_default = b.scriptowner.self_modulate
				b.scriptowner.set_color(color_delete_indicate)
			for u in get_selected_bundles():
				u.scriptowner.set_temporary_color(color_delete_indicate)
		else:
			for b in get_selected_boxes():
				b.scriptowner.set_color(b.scriptowner.color_default)
			for u in get_selected_bundles():
				u.scriptowner.set_temporary_color(u.scriptowner.color_normal)

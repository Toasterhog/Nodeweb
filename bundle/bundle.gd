extends Control
class_name BundleClass

@onready var state_machine: Node = get_node("/root/Main/state_machine_tools")
@onready var BuH: Node2D = get_node("/root/Main/papper/bundleHolder")
var id = -1

var is_dragging := false
var drag_offset := Vector2.ZERO
var mouse_inside := false
#var middlepos : Vector2

var is_scaling := false
var is_scaling2 := false
var cornerpos : Vector2
var half_drag_button_width = 17.5
@onready var panel: Panel = $Panel
@onready var drag_button_1: Button = $Panel/drag_button
@onready var drag_button_2: Button = $Panel/drag_button2
@onready var text_edit: TextEdit = $Panel/PanelContainer/TextEdit
var color_normal
var color_delete_indicator := Color(0.8,0,0,1)


 
func _ready() -> void:
	if id == -1:
		id = IdManager.get_new_id()
	#add_to_group("bundles")
	var smtn = get_node("/root/Main/state_machine_tools")
	smtn.ToolChanged.connect(tool_changed)
	if color_normal:
		set_color(color_normal)
	


func _process(_delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset
		#middlepos = global_position + size/2
		
	elif is_scaling:
		var s = get_global_mouse_position() - global_position
		panel.size.x = floor(max(panel.custom_minimum_size.x, s.x + half_drag_button_width))
		panel.size.y = floor(max(panel.custom_minimum_size.y, s.y + half_drag_button_width))
		
	elif is_scaling2:
		global_position = (get_global_mouse_position() - Vector2(half_drag_button_width,half_drag_button_width)).floor()
		panel.size = (cornerpos - global_position).floor()
	
	else:
		set_process(false)

func _on_mouse_entered() -> void:
	mouse_inside = true
	if state_machine.current_state.name == "ToolAddBundle":
		panel.mouse_default_cursor_shape = Control.CURSOR_MOVE
	if state_machine.current_state.name == "tool_delete":
		set_temporary_color(color_delete_indicator)

func _on_mouse_exited() -> void:
	mouse_inside = false
	panel.mouse_default_cursor_shape = Control.CURSOR_ARROW
	if state_machine.current_state.name == "tool_delete":
		set_temporary_color(color_normal)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if state_machine.current_state.name == "tool_delete":
			delete_self()
	
	
	if event is InputEventMouseButton:
		if state_machine.current_state.name == "ToolAddBundle"  and event.button_index == MOUSE_BUTTON_LEFT\
		or state_machine.current_state.name == "tool_edit" and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_dragging = true
				set_process(true)
				drag_offset = get_global_mouse_position() - global_position
			elif not event.pressed:
				is_dragging = false
				
			#if event.button_index == MOUSE_BUTTON_LEFT: #if tooladdbundle: prevent adding bundle when try move one
				#get_viewport().set_input_as_handled()
	
	if state_machine.current_state.name == "ToolColor" and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		set_color(state_machine.get_node("ToolAddBundle").default_color)
	


func delete_self():
	const endsiz := Vector2(0.8, 0)
	var siz : Vector2 = get_node("Panel").size
	var posoff : Vector2 = Vector2((1 - endsiz.x)/2, (1 - endsiz.y)/2 ) * siz
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", endsiz, 0.1)
	tween.parallel().tween_property(self, "position", posoff + global_position, 0.1)
	tween.tween_callback(queue_free)
	


func _exit_tree() -> void:
	IdManager.release_id(id)



func _on_drag_button_pressed() -> void:
	set_process(true)
	is_scaling = true


func _on_drag_button_button_up() -> void:
	is_scaling = false


func _on_drag_button_2_pressed() -> void:
	set_process(true)
	is_scaling2 = true
	cornerpos = global_position + panel.size


func _on_drag_button_2_button_up() -> void:
	is_scaling2 = false



func tool_changed(tool):
	
	match tool:
		"ToolAddBundle":
			drag_button_1.show()
			drag_button_2.show()
			text_edit.mouse_filter = MOUSE_FILTER_IGNORE
		"tool_edit":
			drag_button_1.show()
			drag_button_2.show()
			text_edit.mouse_filter = MOUSE_FILTER_STOP
		_:
			drag_button_1.hide()
			drag_button_2.hide()
			text_edit.mouse_filter = MOUSE_FILTER_IGNORE
		
		
		

func _on_panel_container_minimum_size_changed() -> void:
	panel.custom_minimum_size.x = $Panel/PanelContainer.size.x + 60
	panel.custom_minimum_size.y = $Panel/PanelContainer.size.y + 60
	
func set_color(new_color):
	color_normal = new_color
	set_temporary_color(new_color)

	
func set_temporary_color(new_color):
	panel.self_modulate = new_color
	drag_button_1.modulate = new_color
	drag_button_2.modulate = new_color
	

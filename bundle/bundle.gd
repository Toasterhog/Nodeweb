extends Control
class_name BundleClass

@onready var state_machine: Node = get_node("/root/Main/state_machine_tools")

var id = -1

var is_dragging := false
var drag_offset := Vector2.ZERO
var mouse_inside := false
var middlepos : Vector2

var is_scaling := false
var is_scaling2 := false
var cornerpos : Vector2
var half_drag_button_width = 17.5
@onready var panel: Panel = $Panel

@onready var BuH: Node2D = get_node("/root/Main/papper/bundleHolder")

 
func _ready() -> void:
	if id == -1:
		id = IdManager.get_new_id()
	#add_to_group("bundles")
	


func _input(event: InputEvent) -> void:

	
	if event is InputEventMouseButton:
		if state_machine.current_state.name == "ToolAddBundle"  and event.button_index == MOUSE_BUTTON_LEFT\
		or state_machine.current_state.name == "tool_edit" and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed  and mouse_inside:
				is_dragging = true
				set_process(true)
				drag_offset = get_global_mouse_position() - global_position
			elif not event.pressed:
				is_dragging = false
				
	


func _process(_delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset
		middlepos = global_position + size/2
		
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

func _on_mouse_exited() -> void:
	mouse_inside = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if state_machine.current_state.name == "tool_delete":
			delete_self()

func delete_self():
	pivot_offset = size / 2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0), 0.1)
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

#TODO
#save and load bundles
#color
#improve look (TE + minipanel)
#extra: cameramove on MMB oftener inbut
#copy paste boxes or better selected regions

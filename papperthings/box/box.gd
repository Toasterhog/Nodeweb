extends Panel
class_name BoxClass

@export var id: int = -1
@export var links: Array = []

signal moved  # Emits when the box moves

# Find ToolAddLink dynamically to prevent cyclic reference
@onready var tool_add_link: ToolAddLink = get_tree().get_first_node_in_group("tool_add_link")
@onready var state_machine := get_node("/root/Main/state_machine_tools")
@onready var VBC: VBoxContainer = $VBoxContainer
@onready var HBC: HBoxContainer = $VBoxContainer/HBoxContainer
@onready var TE: TextEdit = $VBoxContainer/TextEdit
@onready var LE: TextEdit = $VBoxContainer/LineEdit


var is_dragging := false
var is_flowing := true
var drag_offset := Vector2.ZERO
var mouse_inside := false
var middlepos : Vector2

@onready var BH: Node2D = get_node("/root/Main/papper/boxHolder")

 
func _ready() -> void:
	if id == -1:
		id = IdManager.get_new_id()
	add_to_group("boxes")
	update_vbc_and_panel_size()

#### gui input only called if mouse point is in gui rect
### there is a has_point() method

func _input(event: InputEvent) -> void:

	#if mouse_inside and event is InputEventMouseButton and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		#await get_tree().process_frame
		#var te = $VBoxContainer/TextEdit
		#te.grab_focus()
		
	if TE.has_focus() or LE.has_focus():
		if (mouse_inside == false and event is InputEventMouseButton and event.pressed\
		and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT)) \
		or (event is InputEventKey and event.is_action_pressed("ui_cancel")):
			if LE.has_focus():
				LE.release_focus()
			else:
				TE.release_focus()
	
	
	if event is InputEventMouseButton:
		if state_machine.current_state.name == "tool_add_box"  and event.button_index == MOUSE_BUTTON_LEFT\
		or state_machine.current_state.name == "tool_edit" and event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed  and mouse_inside:
				is_dragging = true
				set_process(true)
				drag_offset = get_global_mouse_position() - global_position
			elif not event.pressed:
				is_dragging = false
				is_flowing = true
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MASK_RIGHT \
	and event.double_click and mouse_inside:
		show_notes()
	


func _process(_delta: float) -> void:
	
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset
		middlepos = global_position + size/2
		moved.emit()
		
		for i in BH.get_children(): #notify others
			if i == self  : 
				continue # skip self
			
			var direction = middlepos - i.middlepos
			var overlapX = -abs(direction.x) + size.x/2 + i.size.x/2  
			var overlapY = -abs(direction.y) + size.y/2 + i.size.y/2
			if overlapX > 0 and overlapY > 0:
				i.is_flowing = true
				i.set_process(true)
		
	elif is_flowing:
		flow()
	else:
		set_process(false)

func _on_mouse_entered() -> void:
	if tool_add_link and state_machine.current_state.name == "ToolAddLink":
		tool_add_link.mouse_over_box(self)
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: #delete
		if state_machine.current_state.name == "tool_delete":
			delete_self()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and state_machine.current_state.name == "ToolColor": #color
			var col = state_machine.get_node("tool_add_box").default_color
			set_color(col)

func show_notes():
	if TE.visible:
		TE.visible = false
	else:
		TE.visible = true
	update_vbc_and_panel_size()

func update_vbc_and_panel_size():
	VBC.size = Vector2.ZERO
	size = VBC.size
	middlepos = global_position + size/2
	moved.emit()

#@export var curve : Curve
#func flow2():
	#
	#var velocity := Vector2.ZERO
	#for i in BH.get_children():
		#if i == self  : 
			#continue # skip self
		#
		#var distance : float = position.distance_to(i.position)
		#
		#if distance > curve.max_domain:
			#distance = curve.max_domain # get distance and clamp / ignore
		#
		#var sample : float = curve.sample(distance) #get curve sample
		#
		#if sample < -0.2 or sample > 0.2:
			#i.is_flowing = true # notify other box it needs to flow
			#i.set_process(true)
		#
		#var direction : Vector2 = (i.position - position) ##.normalized()
		#direction = direction.normalized()
		#
		#velocity += direction * sample
	#
	#global_position += velocity 
	#moved.emit()
	#
	#if velocity.length() < 0.1:
		#is_flowing = false

func flow():
	var velocity = Vector2.ZERO
	middlepos = position + size/2
	
	for i in BH.get_children():
		if i == self  : 
			continue # skip self
		
		var direction = middlepos - i.middlepos
		var overlapX = -abs(direction.x) + size.x/2 + i.size.x/2  
		var overlapY = -abs(direction.y) + size.y/2 + i.size.y/2
		if overlapX > 0 and overlapY > 0:
			i.is_flowing = true
			i.set_process(true)
			if overlapX < overlapY:
				velocity.x += (overlapX/16 + 1 ) * sign(direction.x)
			else:
				velocity.y += (overlapY/16 + 1 ) * sign(direction.y)
	
	if velocity.length() == 0:
		is_flowing = false
	else:
		global_position += velocity
		moved.emit()


func delete_self():
	pivot_offset = size / 2
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.8, 0), 0.1)
	tween.tween_callback(queue_free)

func _exit_tree() -> void:
	IdManager.release_id(id)

func set_color(color : Color):
	self_modulate = color

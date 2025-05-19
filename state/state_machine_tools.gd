extends Node

var current_state : State = State.new()
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.Transisioned.connect(child_transision)
	print(states)
	_on_color_picker_button_popup_closed()


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _input(event: InputEvent) -> void:
	
	if current_state:
		current_state.input(event)

func _unhandled_input(event: InputEvent) -> void:
	main_input() 
	if current_state:
		current_state.unhandled_input(event)

func child_transision(new_state_name):
	var new_state = states.get(new_state_name)
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state



func _on_box_button_down() -> void:
	child_transision("tool_add_box")
	vis_indicator_button("box")

func _on_link_button_down() -> void:
	child_transision("ToolAddLink")
	vis_indicator_button("link")

func _on_bundle_button_down() -> void:
	child_transision("ToolAddBundle")
	vis_indicator_button("bundle")
	
func _on_edit_button_down() -> void:
	child_transision("tool_edit")
	vis_indicator_button("edit")


func _on_erasor_button_down() -> void:
	child_transision("tool_delete")
	vis_indicator_button("erasor")

func main_input(): #ATTENTION this is triggered sometimes when typing text!
	
	if Input.is_action_just_pressed("box"):
		_on_box_button_down()
	if Input.is_action_just_pressed("link"):
		_on_link_button_down()
	if Input.is_action_just_pressed("edit"):
		_on_edit_button_down()
	if Input.is_action_just_pressed("delete"):
		_on_erasor_button_down()
	
	if Input.is_action_just_pressed("savelatest"):
		$"../CanvasLayer/PopupMenu"._on_index_pressed(2)
	elif Input.is_action_just_pressed("save"):
		$"../CanvasLayer/PopupMenu"._on_save_button_up()
		
	
func vis_indicator_button(butt : String):
	$"../CanvasLayer/VBoxContainer/HBoxContainer/box".modulate = Color(1,1,1)
	$"../CanvasLayer/VBoxContainer/HBoxContainer/link".modulate = Color(1,1,1)
	$"../CanvasLayer/VBoxContainer/HBoxContainer/erasor".modulate = Color(1,1,1)
	$"../CanvasLayer/VBoxContainer/HBoxContainer/edit".modulate = Color(1,1,1)
	if not butt: return
	get_node("../CanvasLayer/VBoxContainer/HBoxContainer/%s" % butt).modulate = Color(0.9,0.9,0.2)
	get_node("../CanvasLayer/VBoxContainer/HBoxContainer/%s" % butt).grab_focus()
	


func _on_color_picker_button_popup_closed() -> void:
	var color = $"../CanvasLayer/VBoxContainer/HBoxContainer2/ColorPickerButton".color
	$"../CanvasLayer/VBoxContainer/HBoxContainer2/ColorPickerButton/Button".modulate = color
	$tool_add_box.default_color = color

extends Control

var selecting : bool = false
var drag_start : Vector2
var select_box : Rect2

var selected_items : Array = []
var ongoing_selected_items : Array = []

func _input(event: InputEvent) -> void:
	if not Input.is_key_pressed(KEY_SHIFT):
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:     #press LMB
			selecting = true
			drag_start = event.position
		else:                 #relese LMB
			selecting = false
			if is_equal_almost(drag_start, event.position):
				select_box = Rect2(event.position, Vector2.ZERO)
				update_selected_items_reverse()
			else:
				update_selected_items()
				for i in ongoing_selected_items.size():
					add_to_selected(ongoing_selected_items.pop_back())
				#selected_items.append_array(ongoing_selected_items)
				ongoing_selected_items.clear()
			queue_redraw()
	elif selecting and event is InputEventMouseMotion:
		var x_min = min(drag_start.x, event.position.x)
		var y_min = min(drag_start.y, event.position.y)
		select_box = Rect2(x_min, y_min,
			max(drag_start.x, event.position.x) - x_min,
			max(drag_start.y, event.position.y) - y_min)
		update_selected_items()
		queue_redraw()


func _draw() -> void:
	if not selecting: return
	draw_rect(select_box, Color(.5,.7,.7,.2))
	draw_rect(select_box, Color(.4,.5,.6,1), false, 4.0)

func update_selected_items():
	var world_select_box = screen_to_world(select_box)
	for item in get_tree().get_nodes_in_group('selectable_items'):
		var is_in_ongoing_array = ongoing_selected_items.has(item)
		if item.is_in_selectionbox(world_select_box):
			if not is_in_ongoing_array and not selected_items.has(item):
				item.select()
				ongoing_selected_items.append(item)
		elif is_in_ongoing_array:
			item.deselect()
			ongoing_selected_items.erase(item)

func update_selected_items_reverse():
	var world_select_point = screen_to_world(select_box).position
	for item in get_tree().get_nodes_in_group('selectable_items'):
		if item.area_has_selectionpoint(world_select_point):
			if not selected_items.has(item):
				item.select()
				add_to_selected(item)
			else:
				item.deselect()
				remove_from_selected(item)
			return
	clear_selection()

func screen_to_world(box : Rect2) -> Rect2:
	var start_world =  get_viewport().get_canvas_transform().affine_inverse() * box.position
	var end_world = get_viewport().get_canvas_transform().affine_inverse() * box.end
	var rect_world := Rect2(
		start_world,
		end_world - start_world
		)
	return rect_world

func add_to_selected(item):
	selected_items.append(item)
	item.hitbox.gui_input.connect(distribute_gui_input)
	send_gui.connect(item.hitbox._gui_input)
	item.hitbox.mouse_inside = true
	
func remove_from_selected(item):
	selected_items.erase(item)
	item.hitbox.gui_input.disconnect(distribute_gui_input)
	send_gui.disconnect(item.hitbox._gui_input)
	

func clear_selection():
	for item in selected_items:
		item.deselect()
	selected_items.clear()

func is_equal_almost(a : Vector2, b : Vector2):
	var differance = abs(a-b)
	return differance.x + differance.y < 40


signal send_gui(e: InputEvent)

func distribute_gui_input(e):
	#send_gui.emit(e)
	for s in selected_items:
		s.hitbox._gui_input(e)
	
#conect gui_input signal from selected.hitbox (or selected.smt_else) to some centralized thing here
#connect centralized thing signal to selected.scrip_having_node.gui_input
#use selection for bundle push back

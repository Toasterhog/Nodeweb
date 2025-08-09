extends Control

var selecting : bool = false
var drag_start : Vector2
var select_box : Rect2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selecting = true
			drag_start = event.position
		else:
			selecting = false
			if drag_start.is_equal_approx(event.position):
				select_box = Rect2(event.position, Vector2.ZERO)
			update_selected_units()
			queue_redraw()
	elif selecting and event is InputEventMouseMotion:
		var x_min = min(drag_start.x, event.position.x)
		var y_min = min(drag_start.y, event.position.y)
		select_box = Rect2(x_min, y_min,
			max(drag_start.x, event.position.x) - x_min,
			max(drag_start.y, event.position.y) - y_min)
		update_selected_units()
		queue_redraw()


func _draw() -> void:
	if not selecting: return
	draw_rect(select_box, Color(.5,.7,.7,.2))
	draw_rect(select_box, Color(.4,.5,.6,1), false, 4.0)

func update_selected_units():
	var world_select_box = screen_to_world(select_box)
	for unit in get_tree().get_nodes_in_group('selectable_units'):
		if unit.is_in_selectionbox(world_select_box):
			unit.select()
		else:
			unit.deselect()
	
func screen_to_world(box : Rect2) -> Rect2:
	var start_world =  get_viewport().get_canvas_transform().affine_inverse() * box.position
	var end_world = get_viewport().get_canvas_transform().affine_inverse() * box.end
	var rect_world := Rect2(
		start_world,
		end_world - start_world
		)
	return rect_world

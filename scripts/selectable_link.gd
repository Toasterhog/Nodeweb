extends SelectableItem
class_name SelectableLink


func _ready() -> void:
	add_to_group('selectable_items')
	
	hitbox.connect("input_event", area_input)


func is_in_selectionbox(box : Rect2):
	return box.has_point((outline.points[0] + outline.points[1]) / 2)

func area_has_selectionpoint(point : Vector2):
	return false #hitbox.overlaps_area()#somehow check if area or collisionshape2d has point 
	#use area signals probably

func area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	print("ae")
	if event is InputEventMouseMotion: return
	if Input.is_key_pressed(KEY_SHIFT) and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("shifty iuinput")
		if $/root/Main/CanvasLayer/SelectionSystem.selected_items.has(self):
			$/root/Main/CanvasLayer/SelectionSystem.selected_items.erase(self)
			deselect()
			print("desel line")
		else:
			$/root/Main/CanvasLayer/SelectionSystem.selected_items.append(self)
			select()
			print("desel line2")



func select():
	outline.modulate = Color(1,.2,.8)

func deselect():
	outline.modulate = Color(1, 1, 1)


func _exit_tree() -> void:
	$/root/Main/CanvasLayer/SelectionSystem.remove_from_selected(self)
	deselect()

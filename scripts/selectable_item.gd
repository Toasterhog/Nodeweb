extends Control
class_name SelectableItem

@export var outline : Node

func _ready() -> void:
	outline.hide()
	add_to_group('selectable_units')


func is_in_selectionbox(box : Rect2):
	return box.has_point(global_position)

func select():
	print("got selected")
	outline.show()

func deselect():
	outline.hide()



func screen_to_world(box : Rect2):
	var start_world =  get_viewport().get_canvas_transform().affine_inverse() * box.position
	var end_world = get_viewport().get_canvas_transform().affine_inverse() * box.end

	var rect_world := Rect2(
		start_world,
		end_world - start_world
		)
	#).abs() # abs() makes width/height positive
	print("box.p ",box.position)
	print("wordl start ",start_world)
	return rect_world

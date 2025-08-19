extends Control
class_name SelectableItem

@export var outline : Node
@export var hitbox : Control

func _ready() -> void:
	outline.hide()
	add_to_group('selectable_items')


func is_in_selectionbox(box : Rect2):
	return box.has_point(global_position)

func area_has_selectionpoint(point : Vector2):
	return Rect2(hitbox.global_position, hitbox.size).has_point(point)

func select():
	feedback()

func deselect():
	defeedback()

func feedback():
	outline.show()

func defeedback():
	outline.hide()

func _exit_tree() -> void:
	$/root/Main/CanvasLayer/SelectionSystem.remove_from_selected(self)
	deselect()

extends Resource
class_name BoxProperties

@export var id : int
@export var pos : Vector2
@export var color : Color
@export var LineText : String
@export var BodyText : String
@export var expanded : bool
@export var cust_width_fold : float = 0
@export var cust_width_expnd : float = 0

static func item_to_resource(item: BoxClass) -> Resource:
	var res = BoxProperties.new()
	res.id = item.id
	res.pos = item.position
	res.color = item.self_modulate
	res.LineText = item.get_node("MarginContainer/VBoxContainer/LineEdit").text
	res.BodyText = item.get_node("MarginContainer/VBoxContainer/TextEdit").text
	res.expanded = item.get_node("MarginContainer/VBoxContainer/TextEdit").visible
	res.cust_width_fold = item.cust_width_fold
	res.cust_width_expnd = item.cust_width_expnd
	return res


##Returns a box instance based on propertyresource.  NOTE: id +1000 | vbc&panel not updated | not clamped to camera limits
static func resource_to_item(res: BoxProperties) -> BoxClass:
	var box = preload("uid://wfnqhd3r5fxx").instantiate() #box scene
	box.get_node("MarginContainer/VBoxContainer/LineEdit").text = res.LineText
	box.get_node("MarginContainer/VBoxContainer/TextEdit").text = res.BodyText
	box.set_color(res.color)
	box.position = res.pos
	box.get_node("MarginContainer/VBoxContainer/TextEdit").visible = res.expanded
	box.get_node("MarginContainer/VBoxContainer/HSeparator").visible = res.expanded
	box.id = res.id + 1000
	box.cust_width_fold = res.cust_width_fold
	box.cust_width_expnd = res.cust_width_expnd
	return box

extends Resource
class_name BundleProperties

@export var id : int
@export var pos : Vector2
@export var color : Color
@export var size : Vector2
@export var label : String


static func item_to_resource(item: BundleClass) -> Resource:
	var res = BundleProperties.new()
	res.id  = item.id
	res.pos = item.position
	res.size = item.get_node("Panel").size
	res.color = item.get_node("Panel").modulate
	res.label = item.get_node("Panel/PanelContainer/TextEdit").text
	return res

##Returns a bundle instance based on propertyresource.  NOTE: id +1000 |  not clamped to camera limits
static func resource_to_item(res: BundleProperties) -> BundleClass:
	var bundle = preload("uid://bhwvnws1rjko1").instantiate() #bundle scene
	bundle.id = res.id + 1000
	bundle.position = res.pos
	bundle.get_node("Panel").modulate = res.color
	bundle.get_node("Panel").size = res.size
	bundle.get_node("Panel/PanelContainer/TextEdit").text = res.label
	return bundle

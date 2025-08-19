extends Resource
class_name LinkProperties

@export var start_box : int
@export var end_box : int
@export var color : Color
@export_enum("link", "arrow") var link_type : int = 0

static func item_to_resource(item: Link) -> Resource:
	var res = LinkProperties.new()
	res.start_box = item.start_box.id
	res.end_box = item.end_box.id
	res.color = item.base_color
	res.link_type = 0
	return res

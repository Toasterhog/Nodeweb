extends FileDialog

var path = null
@onready var box_holder: Node2D = $"../../papper/boxHolder"
@onready var link_holder: Node2D = $"../../papper/linkHolder"
@onready var arrowholder: Node2D = $"../../papper/arrowholder"
@onready var bundle_holder: Node2D = $"../../papper/bundleHolder"
const BOX = preload("uid://wfnqhd3r5fxx")
const LINK = preload("uid://bbfr0s07ij6tq")
const BUNDLE = preload("res://bundle/bundle.tscn")
const ARROW = preload("res://papperthings/link/directional_link/link_directional.tscn")
func _on_load_button_up() -> void:
	#current_dir = OS.get_user_data_dir()
	popup_centered()

func _on_file_selected(filepath: String) -> void:
	path = filepath
	print("selected path: ", path)
	if not $"../SaveDialog".path:
		$"../SaveDialog".path = path
	palce_to_papper()




func palce_to_papper():
	if not ResourceLoader.exists(path):
		print("rotten file bleh")
		return
		
	var doc : DocumentClass = ResourceLoader.load(path)
	var c : Camera2D = $"../../papper/Camera2D"
	var num_boxes_from_before : int = box_holder.get_child_count()
	
	#place boxes
	for res in doc.box_res_array:
		var box = BoxProperties.resource_to_item(res) #note id +1000
		box_holder.add_child(box)
		box.update_vbc_and_panel_size()
		box.position = box.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
	
	#place bundles
	for res in doc.bundle_res_array:
		var bundle = BundleProperties.resource_to_item(res)
		bundle_holder.add_child(bundle)
		bundle.position = bundle.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
	
	#place links and arrows (theres no reason for them to be combined)
	for res in doc.link_res_array:
		if res.start_box + num_boxes_from_before >= box_holder.get_child_count() or\
		res.end_box + num_boxes_from_before >= box_holder.get_child_count():
			return # no out of bounds children
		
		match res.link_type:
			0:
				var link = LINK.instantiate()
				link.base_color = res.color
				link.start_box = box_holder.get_child( res.start_box + num_boxes_from_before)
				link.end_box = box_holder.get_child( res.end_box + num_boxes_from_before)
				link_holder.add_child(link)
			1:
				var link = ARROW.instantiate() #this looks messy and is weird
				link.base_color = res.color
				link.start_box = box_holder.get_child( res.start_box + num_boxes_from_before)
				link.end_box = box_holder.get_child( res.end_box + num_boxes_from_before)
				arrowholder.add_child(link)
				
	
	IdManager.reset_ids()

extends Control
class_name SelectionCopyPaste

@onready var selection_system: SelectionSystem = $".."
@onready var selection_actions: SelectionActions = $"../SelectionActions"
var clipboard : DocumentClass

func cp_input(e : InputEvent):
	if e is InputEventKey and e.keycode == KEY_C and e.pressed: #replace with action to avoid echo
		selection_to_document()


func selection_to_document(): #pos relative to mouse, or + mousepos at pste
	IdManager.reset_ids() #why not idk
	var document = DocumentClass.new()
	
	
	
	
	for b in selection_actions.get_selected_boxes():
		document.box_res_array.append(BoxProperties.item_to_resource(b.scriptowner))
	
	for u in selection_actions.get_selected_bundles():
		document.bundle_res_array.append(BundleProperties.item_to_resource(u.scriptowner))
	
	for l in derive_links():
		document.link_res_array.append(LinkProperties.item_to_resource(l))
		
	for a in derive_arrows():
		var res = LinkProperties.item_to_resource(a)
		res.link_type = 1
		document.link_res_array.append(res)
	
	clipboard = document
	print("suces")


func document_to_hologram_instances(doc : Resource):
	pass


func hologram_to_normal_instances():
	pass


func derive_links():
	var derived_links = []
	var sel_nodes = selection_actions.get_selected_boxes()
	if sel_nodes.size() < 2: return #cant exist any links
	var boxes = [] #.resize(sel_nodes.size())
	for s in sel_nodes:
		boxes.append(s.scriptowner)
	
	for box_a in boxes:
		for box_b in boxes: #could be optimized by keeping box_b always higher than a (by index)
			if box_a == box_b: continue
			for link_a in box_a.links:
				for link_b in box_b.links:
					if link_a == link_b and link_a not in derived_links:
						derived_links.append(link_a)
	return derived_links
	
func derive_arrows():
	var derived_links = []
	var sel_nodes = selection_actions.get_selected_boxes()
	if sel_nodes.size() < 2: return #cant exist any links
	var boxes = [] #.resize(sel_nodes.size())
	for s in sel_nodes:
		boxes.append(s.scriptowner)
	
	for box_a in boxes:
		for box_b in boxes: #could be optimized by keeping box_b always higher than a (by index)
			if box_a == box_b: continue
			for link_a in box_a.arrows:
				for link_b in box_b.arrows:
					if link_a == link_b and link_a not in derived_links:
						derived_links.append(link_a)
	return derived_links
	

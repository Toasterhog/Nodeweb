extends Control
class_name SelectionCopyPaste

var is_pasting : bool = false
@onready var selection_system: SelectionSystem = $".."
@onready var selection_actions: SelectionActions = $"../SelectionActions"
var clipboard : DocumentClass
var mouse_pos_when_copy : Vector2
@onready var hologram_holder: Node2D = $"../../../papper/hologramHolder"
var hologram_color = Color(0.2,0.4,0.9,0.6)
const LINK = preload("res://papperthings/link/link.tscn")
const ARROW = preload("res://papperthings/link/directional_link/link_directional.tscn")

func cp_input(e : InputEvent): #called from selection_actions
	if Input.is_action_just_pressed("ui_copy"): 
		selection_to_document()
		
	elif Input.is_action_just_pressed("ui_paste"):
		if clipboard and hologram_holder.get_child_count() == 0: #not paste multiple times into hologram witout clearing in betwen
			document_to_hologram_instances(clipboard)
	
	elif Input.is_action_just_pressed("ui_graph_duplicate"):
		selection_to_document()
		document_to_hologram_instances(clipboard)
	
	elif is_pasting:
		update_hologram()
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed:
			document_to_normal_instances()
			get_viewport().set_input_as_handled()
		elif e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_RIGHT and e.pressed\
		or Input.is_action_just_pressed("ui_cancel"):
			clear_hologram()
			get_viewport().set_input_as_handled()
	
	else:
		return
	get_viewport().set_input_as_handled() #set as handled if any of above ran, else quit before and not set as handled

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
	mouse_pos_when_copy = hologram_holder.get_global_mouse_position() #hh bc just to be at the right canvaslayer
	print("copied")

func document_to_hologram_instances(clipboard : DocumentClass):
	if not clipboard:
		print("rotten clipb bleh")
		return
	is_pasting = true
	
	var doc : DocumentClass = clipboard
	var c : Camera2D = $"../../../papper/Camera2D"
	#var num_boxes_from_before : int = $"../../../papper/boxHolder".get_child_count()
	var hol_box_newID_dict = {}
	#place boxes
	for res in doc.box_res_array:
		var box = BoxProperties.resource_to_item(res) #note id +1000
		box.set_color(hologram_color)
		hologram_holder.add_child(box)
		hol_box_newID_dict[box.id] = box
		box.update_vbc_and_panel_size()
		#box.position = box.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
	
	#place bundles
	for res in doc.bundle_res_array:
		var bundle = BundleProperties.resource_to_item(res)
		hologram_holder.add_child(bundle)
		bundle.set_color(hologram_color)
		#bundle.position = bundle.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
	
	#place links and arrows (theres no reason for them to be combined)
	for res in doc.link_res_array:
	#	if res.start_box + num_boxes_from_before >= box_holder.get_child_count() or\
	#	res.end_box + num_boxes_from_before >= box_holder.get_child_count():
	#		return # no out of bounds children
		
		match res.link_type:
			0:
				var link = LINK.instantiate()
				link.base_color = res.color
				link.start_box = hol_box_newID_dict[res.start_box + 1000]
				link.end_box = hol_box_newID_dict[res.end_box + 1000]
				hologram_holder.add_child(link)
				link.update_line()
			1:
				var link = ARROW.instantiate() #this looks messy and is weird
				link.base_color = res.color
				link.start_box = hol_box_newID_dict[res.start_box + 1000]
				link.end_box = hol_box_newID_dict[res.end_box + 1000]
				hologram_holder.add_child(link)
				link.update_line()
				
	IdManager.reset_ids()

func document_to_normal_instances():
	clear_hologram()
	if not clipboard:
		print("no clipboard")
		return
	
	var bundle_holder: Node2D = $"../../../papper/bundleHolder"
	var link_holder: Node2D = $"../../../papper/linkHolder"
	var arrowholder: Node2D = $"../../../papper/arrowholder"
	var box_holder: Node2D = $"../../../papper/boxHolder"
	
	var doc : DocumentClass = clipboard
	var c : Camera2D = $"../../../papper/Camera2D"
	#var num_boxes_from_before : int = box_holder.get_child_count()
	var offset =  bundle_holder.get_global_mouse_position() - mouse_pos_when_copy
	var box_newID_dict = {}
	
	#place boxes
	for res in doc.box_res_array:
		var box = BoxProperties.resource_to_item(res) #note id +1000
		box_holder.add_child(box)
		box.update_vbc_and_panel_size()
		box.position += offset
		box.position = box.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
		box_newID_dict[box.id] = box
	
	#place bundles
	for res in doc.bundle_res_array:
		var bundle = BundleProperties.resource_to_item(res)
		bundle_holder.add_child(bundle)
		bundle.position += offset
		bundle.position = bundle.position.clamp(Vector2(c.limit_left,c.limit_top),Vector2(c.limit_right -300,c.limit_bottom - 300))
	
	#place links and arrows (theres no reason for them to be combined)
	for res in doc.link_res_array:
		#if res.start_box + num_boxes_from_before >= box_holder.get_child_count() or\
		#res.end_box + num_boxes_from_before >= box_holder.get_child_count():
			#return # no out of bounds children
		
		match res.link_type:
			0:
				var link = LINK.instantiate()
				link.base_color = res.color
				link.start_box = box_newID_dict[res.start_box + 1000]
				link.end_box = box_newID_dict[res.end_box + 1000]
				link_holder.add_child(link)
			1:
				var link = ARROW.instantiate() #this looks messy and is weird
				link.base_color = res.color
				link.start_box = box_newID_dict[res.start_box + 1000]
				link.end_box = box_newID_dict[res.end_box + 1000]
				arrowholder.add_child(link)
				
	IdManager.reset_ids()

func update_hologram():
	hologram_holder.position = hologram_holder.get_global_mouse_position() - mouse_pos_when_copy

func clear_hologram():
	hologram_holder.position = Vector2.ZERO
	for kid in hologram_holder.get_children():
		kid.queue_free()
	is_pasting = false

func derive_links():
	var derived_links = []
	var sel_nodes = selection_actions.get_selected_boxes()
	if sel_nodes.size() < 2: return derived_links #cant exist any links
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
	if sel_nodes.size() < 2: return derived_links #cant exist any links
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

extends FileDialog

var path = null
@onready var box_holder: Node2D = $"../../papper/boxHolder"
@onready var link_holder: Node2D = $"../../papper/linkHolder"
@onready var bundle_holder: Node2D = $"../../papper/bundleHolder"
const BOX = preload("uid://wfnqhd3r5fxx")
const LINK = preload("uid://bbfr0s07ij6tq")
const BUNDLE = preload("res://bundle/bundle.tscn")

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
	var res : DocumentClass
	if ResourceLoader.exists(path):
		res = ResourceLoader.load(path)
	else: 
		print("rotten file bleh")
		return
	
	
	var A_id := res.id
	var A_position := res.pos
	var A_color := res.color
	var A_LE := res.LineText
	var A_TE := res.BodyText
	var A_ex := res.expanded
	
	var LinkS := res.link_sb
	var LinkE := res.link_eb
	
	var Bid := res.bundle_id
	var Bpos := res.bundle_pos
	var Bsize := res.bundle_size
	var Bcolor := res.bundle_color
	var Blabel := res.bundle_label
	
	for i in A_position.size():
		
		var box := BOX.instantiate()
		var LE := box.get_node("MarginContainer/VBoxContainer/LineEdit")
		var TE := box.get_node("MarginContainer/VBoxContainer/TextEdit")
		
		LE.text = A_LE[i]
		TE.text = A_TE[i]
		box.set_color(A_color[i])
		box.position = A_position[i]
		box.get_node("MarginContainer/VBoxContainer/TextEdit").visible = A_ex[i]
		box.id = A_id[i] + 1000
		box_holder.add_child(box)
		box.update_vbc_and_panel_size()
		
	for i in LinkS.size():
		var link = LINK.instantiate()
		var startbox
		var endbox 
		
		for b in box_holder.get_children():
			if b.id == LinkS[i] + 1000:
				startbox = b
			elif b.id == LinkE[i] + 1000:
				endbox = b
		
		if startbox == null or endbox == null:
			continue #dont instantica invalid link
		link.start_box = startbox
		link.end_box = endbox
		link_holder.add_child(link)
	
	for i in Bid.size():
		var bundle := BUNDLE.instantiate()
		
		bundle.position = Bpos[i]
		bundle.get_node("Panel").size = Bsize[i]
		bundle.get_node("Panel").modulate = Bcolor[i]
		bundle.get_node("PanelContainer/TextEdit").text = Blabel[i]
		
		#bundle.id = Bid[i] + 1000
		bundle_holder.add_child(bundle)
	
	
	
	IdManager.reset_ids()
	
	
	
	
	
	
	
	
	
	
	
	
	

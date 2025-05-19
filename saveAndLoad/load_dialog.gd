extends FileDialog

var path = null
@onready var box_holder: Node2D = $"../../papper/boxHolder"
@onready var link_holder: Node2D = $"../../papper/linkHolder"
const BOX = preload("res://papperthings/box.tscn")
const LINK = preload("res://papperthings/link.tscn")

func _on_load_button_up() -> void:
	#current_dir = OS.get_user_data_dir()
	popup_centered()


func _on_file_selected(filepath: String) -> void:
	path = filepath
	print("selected path: ", path)
	palce_to_papper()

func palce_to_papper():
	var res : DocumentClass
	if ResourceLoader.exists(path):
		print("existed")
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
	
	for i in A_position.size():
		
		var box := BOX.instantiate()
		var LE := box.get_node("VBoxContainer/HBoxContainer/LineEdit")
		var TE := box.get_node("VBoxContainer/TextEdit")
		var CP := box.get_node("VBoxContainer/HBoxContainer/ColorPickerButton")
		
		LE.text = A_LE[i]
		TE.text = A_TE[i]
		CP.color = A_color[i]
		box.self_modulate = A_color[i]
		box.position = A_position[i]
		box.get_node("VBoxContainer/TextEdit").visible = A_ex[i]
		box.get_node("VBoxContainer/HBoxContainer/ColorPickerButton").visible = A_ex[i]
		box.id = A_id[i] + 1000
		box_holder.add_child(box)
		
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
	
	IdManager.reset_ids()
	
	
	
	
	
	
	
	
	
	
	
	
	

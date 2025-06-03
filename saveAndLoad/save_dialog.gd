extends FileDialog

var path: String = ""
var savefolder : String = ""
const DOCUMENT_PRESET_RESOURCE = preload("res://saveAndLoad/document_preset_resource.tres")
@onready var link_holder: Node2D = $"../../papper/linkHolder"
@onready var box_holder: Node2D = $"../../papper/boxHolder"
@onready var bundle_holder: Node2D = $"../../papper/bundleHolder"
@onready var folder_dialog: FileDialog = $"../FolderDialog"
signal button_animate


func name_selected(namee : String) -> bool:
	if not savefolder:
		folder_dialog.popup()
		return false
	if not(namee.is_valid_filename() and namee.contains(".") == false and namee):
		return false
	namee = namee.validate_filename()
	path = savefolder + namee
	_on_file_selected(path)
	return true

func _on_folder_dialog_dir_selected(dir: String) -> void:
	savefolder = dir + "/"
	$"../../CanvasLayer/PopupMenu".UpdateFolderLabel()


func _on_file_selected(file: String) -> void:
	path = file
	tidy_up_pathname()
	save_doc_to_path()
	
func tidy_up_pathname():
	if not path.ends_with(".tres") and path:
		path += ".tres"

	


func save_doc_to_path():
	print("saving to: ", path)
	button_animate.emit()
	var document = DOCUMENT_PRESET_RESOURCE.duplicate()
	
	var length := box_holder.get_child_count()
	document.id.resize(length)
	document.pos.resize(length)
	document.color.resize(length)
	document.LineText.resize(length)
	document.BodyText.resize(length)
	document.expanded.resize(length)
	
	document.link_sb.resize(link_holder.get_child_count())
	document.link_eb.resize(link_holder.get_child_count())
	
	document.bundle_id.resize(bundle_holder.get_child_count())
	document.bundle_pos.resize(bundle_holder.get_child_count())
	document.bundle_size.resize(bundle_holder.get_child_count())
	document.bundle_color.resize(bundle_holder.get_child_count())
	document.bundle_label.resize(bundle_holder.get_child_count())
	
	for b in box_holder.get_children():
		var i = b.get_index()
		document.id[i] = b.id
		document.pos[i] = b.position
		document.color[i] = b.self_modulate
		document.LineText[i] = b.get_node("VBoxContainer/HBoxContainer/LineEdit").text
		document.BodyText[i] = b.get_node("VBoxContainer/TextEdit").text
		document.expanded[i] = b.get_node("VBoxContainer/TextEdit").visible
	
	for l in link_holder.get_children():
		var i = l.get_index()
		document.link_sb[i] = l.start_box.id
		document.link_eb[i] = l.end_box.id
		
	for b in bundle_holder.get_children():
		var i = b.get_index()
		document.bundle_id[i] = i
		document.bundle_pos[i] = b.position
		document.bundle_size[i] = b.get_node("Panel").size
		document.bundle_color[i] = b.get_node("Panel").modulate
		document.bundle_label[i] = b.get_node("PanelContainer/TextEdit").text
	
	ResourceSaver.save(document, path)

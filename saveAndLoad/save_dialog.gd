extends FileDialog

var path: String = ""
var savefolder : String = ""
@onready var link_holder: Node2D = $"../../papper/linkHolder"
@onready var arrowholder: Node2D = $"../../papper/arrowholder"
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
	var document = DocumentClass.new()
	
	IdManager.reset_ids() #why not idk
	#no cus just empty slots probably
	#document.box_res_array.resize(box_holder.get_child_count()) #optional but prop saves performance
	
	for b in box_holder.get_children():
		document.box_res_array.append(BoxProperties.item_to_resource(b))
	
	for u in bundle_holder.get_children():
		document.bundle_res_array.append(BundleProperties.item_to_resource(u))
	
	for l in link_holder.get_children():
		document.link_res_array.append(LinkProperties.item_to_resource(l))
		
	for a in arrowholder.get_children():
		var res = LinkProperties.item_to_resource(a)
		res.link_type = 1
		document.link_res_array.append(res)
	
	ResourceSaver.save(document, path)

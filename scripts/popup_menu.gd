extends PopupMenu

@onready var save_dialog: FileDialog = $"../../save_load_node/SaveDialog"


func _on_save_button_up() -> void:
	popup_centered()
	if not save_dialog.path:
		set_item_disabled(2, true)
		set_item_text(2, "latest")
	else:
		set_item_disabled(2, false)
		var ending_of_path : String = save_dialog.path.split("/", true)[-1]
		set_item_text(2, "latest: %s" %ending_of_path)


func _on_index_pressed(index: int) -> void:
	match index:
		0:
			save_dialog.popup_centered()
		1:
			$"../pp_SaveName".popup(Rect2i(20,100,230,110))
			$"../pp_SaveName/MarginContainer/vbc/LineEdit".grab_focus()
			UpdateFolderLabel()
		2:
			if save_dialog.path:
				save_dialog.save_doc_to_path()





func _on_line_edit_text_submitted(new_text: String) -> void:
	var name : String = $"../pp_SaveName/MarginContainer/vbc/LineEdit".text
	if save_dialog.name_selected(name):
		$"../pp_SaveName".hide()
	
func UpdateFolderLabel():
	var folder = $"../../save_load_node/SaveDialog".savefolder
	$"../pp_SaveName/MarginContainer/vbc/Label".text = folder

func _on_button_button_up() -> void:
	_on_line_edit_text_submitted(name)


func _on_pp_save_name_close_requested() -> void:
	$"../pp_SaveName".hide()

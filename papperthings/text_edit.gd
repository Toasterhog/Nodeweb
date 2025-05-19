extends TextEdit

#this script not in use, ok to delete

func _on_text_changed() -> void:
	return
	var h = get_line_count() * get_line_height() + 23
	custom_minimum_size.y = h   #TE sixe.y 
	$"..".size.y = 0 #vboxC will automatically resise to fit its children ( but it only recieves automatic update if it needs to stretch not shrink)
	
	var w = get_line_width(get_caret_line()) #get widest line but only if need to
	if w > $"..".custom_minimum_size.x:
		for i in get_line_count():
			w = max(w, get_line_width(i))
		$"..".size.x = w + 10
	
	await get_tree().process_frame  
	$"../..".size = $"..".size   #panel size = vboxc size

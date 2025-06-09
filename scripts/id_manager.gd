extends Node

var next_id: int = 0 ##the highest id in use + 1
var free_ids: Array = []  ## Stores IDs that are NOT in use, and are lower than next_id

func get_new_id() -> int:
	if free_ids.is_empty():
		next_id += 1
		return next_id - 1
	else:
		return free_ids.pop_front()  # Reuse an ID

func release_id(id: int):
	free_ids.append(id)
	free_ids.sort()

##Resets idmanager variables and redistributes IDs
func reset_ids() -> void:
	free_ids.clear()
	next_id = 0
	var bh = get_node("/root/Main/papper/boxHolder")
	for i in bh.get_child_count():
		bh.get_child(i).id = i
		next_id = i+1


#not related to id stuff
var OSmode := &"windows"

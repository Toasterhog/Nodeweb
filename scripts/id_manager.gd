extends Node

var next_id: int = 0
var free_ids: Array = []  # Stores reusable IDs

func get_new_id() -> int:
	if free_ids.is_empty():
		next_id += 1
		return next_id - 1
	else:
		return free_ids.pop_front()  # Reuse an ID

func release_id(id: int):
	free_ids.append(id)
	free_ids.sort()

func reset_ids() -> void:
	var bh = get_node("/root/Main/papper/boxHolder")
	for i in bh.get_child_count():
		bh.get_child(i).id = i

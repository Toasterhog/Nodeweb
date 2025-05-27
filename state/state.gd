extends Node
class_name State


var isactive : bool = false

func enter():
	isactive = true
	print("tool activated: ", self.name)
	
func exit():
	isactive = false

func update(_delta : float):
	pass

func input(_event: InputEvent) -> void:
	pass

func unhandled_input(_event: InputEvent) -> void:
	pass

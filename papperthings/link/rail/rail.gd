extends Node2D
class_name Rail

@onready var parent : BoxClass = get_parent()
@onready var links : Array = parent.links
var points : Array


var size :Vector2 = Vector2(200,200)




func _process(delta: float) -> void:
	var directions = make_directions()
	
	


func make_directions():
	pass

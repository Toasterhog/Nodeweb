extends Node2D
class_name Link

@export var start_box: PanelContainer
@export var end_box: PanelContainer

const  default_width := 8.0
const hover_width := 14.0
var base_color := Color.GRAY
const hover_color := Color.RED

@onready var line := $"."
@onready var collision_shape := $Area2D/CollisionShape2D
@onready var state_machine := get_node("/root/Main/state_machine_tools")


func _ready():
	line.width = default_width
	line.default_color = base_color
	update_line()

	# Connect signals to update when boxes move or are deleted
	if start_box:
		start_box.moved.connect(update_line)
		start_box.tree_exiting.connect(delete_line)
	if end_box:
		end_box.moved.connect(update_line)
		end_box.tree_exiting.connect(delete_line)

	# Connect hover and click detection
	$Area2D.mouse_entered.connect(_on_mouse_entered)
	$Area2D.mouse_exited.connect(_on_mouse_exited)
	$Area2D.input_event.connect(_on_input_event)

func update_line():
	if start_box and end_box:
		line.points = [start_box.middlepos, end_box.middlepos]
		update_collision()

func update_collision():
	if collision_shape and start_box and end_box:
		var shape = collision_shape.shape as CapsuleShape2D
		var p1 : Vector2 =  line.points[0]
		var p2 : Vector2 =  line.points[1]
		shape.height = p1.distance_to(p2)
		shape.radius = 15
		collision_shape.global_position = (p1+p2)/2
		collision_shape.rotation = atan2(p2.y-p1.y, p2.x-p1.x) - PI/2
		

func _on_mouse_entered():
	if state_machine.current_state.name == "tool_delete":
		line.width = hover_width
		line.default_color = hover_color

func _on_mouse_exited():
	line.width = default_width
	line.default_color = base_color

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if state_machine.current_state.name == "tool_delete":
			delete_line()
		

func delete_line():
	if start_box and start_box.links.has(self):
		start_box.links.erase(self)
	if end_box and end_box.links.has(self):
		end_box.links.erase(self)
	queue_free()

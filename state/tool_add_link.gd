extends State
class_name ToolAddLink

var grabbing_box: Panel = null
var is_dragging: bool = false
var link_preview: Line2D = null
var start_box: Panel = null
@onready var papper: Node2D = $"../../papper"
@onready var link_scene = preload("uid://bbfr0s07ij6tq")
@onready var link_holder = $"../../papper/linkHolder"

func enter():
	super.enter()
	grabbing_box = null
	start_box = null
	is_dragging = false
	
func exit():
	super.exit()
	reset_tool()
	
func input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		if grabbing_box:
			start_box = grabbing_box
			is_dragging = true
			#start_box.set_selected(true)  # Highlight the start box
			create_preview_line()

	elif event.is_action_released("LMB"): #NOTE end box will be last hovered box
		if is_dragging and grabbing_box and grabbing_box != start_box:
			if check_if_link_pair_doesnt_exists(start_box, grabbing_box) == true:
				instantiate_link(start_box, grabbing_box)
				

		reset_tool()

	elif is_dragging and event is InputEventMouseMotion:
		update_preview_line(event)

func create_preview_line():
	if link_preview:
		link_preview.queue_free()
	link_preview = Line2D.new()
	link_preview.width = 8
	link_preview.default_color = Color(1, 1, 1, 0.5)  # Semi-transparent white
	papper.add_child(link_preview)

func update_preview_line(event: InputEventMouse):
	if link_preview and start_box:
		var mouse_papper_pos = papper.get_local_mouse_position()
		link_preview.points = [start_box.middlepos, mouse_papper_pos]

func instantiate_link(box_a: Panel, box_b: Panel):
	var link = link_scene.instantiate()
	link.start_box = box_a
	link.end_box = box_b
	
	box_a.links.append(link)
	box_b.links.append(link)

	link_holder.add_child(link)

func reset_tool():
	#if start_box:
		#start_box.set_selected(false)
	start_box = null
	is_dragging = false
	#grabbing_box = null
	if link_preview:
		link_preview.queue_free()
		link_preview = null

func mouse_over_box(box: Panel):
	grabbing_box = box

func check_if_link_pair_doesnt_exists(sb : Panel, eb : Panel) -> bool: #checks if the two boxes has a link between them
	for L: Link in sb.links:
		if L.start_box == eb or L.end_box == eb:
			return false
	return true

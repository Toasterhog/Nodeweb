extends Link
class_name Arrow

#const  default_width := 8.0
#const hover_width := 14.0
#var base_color := Color.GRAY
#const hover_color := Color.RED

func delete_line():
	if start_box and start_box.arrows.has(self):
		start_box.arrows.erase(self)
	if end_box and end_box.arrows.has(self):
		end_box.arrows.erase(self)
	queue_free()


func update_line():
	if start_box and end_box:
		line.points = pointfunc()
		update_collision()
	
	#sprite arrowtip stuff
	var dir : Vector2= (line.points[1] - line.points[0])
	var lerp_t = max( 1 - ( end_box.size.length()*0.5 / dir.length() ), 0.5)
	$Sprite2D.position = lerp(line.points[0], line.points[1], lerp_t)
	$Sprite2D.rotation = dir.angle()

func pointfunc():
	var dir = end_box.position - start_box.position
	var offset = dir.normalized().rotated(0.5*PI) * 24
	return [start_box.middlepos + offset, end_box.middlepos + offset]
	
	
	
	

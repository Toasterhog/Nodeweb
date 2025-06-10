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
		
		#var vec = Vector2(end_box.middlepos - start_box.middlepos )
		#vec = vec.rotated(1.6).normalized() * 50
		var index : int = start_box.arrows.find_custom(finds.bind())
		var gpt_points =  get_line_points(start_box, end_box, start_box.arrows.size(), index)
		#p1: Vector2, p2: Vector2, w1: float, h1: float, w2: float, h2: float, N: int, n: int
		#line.points = [start_box.middlepos + vec, end_box.middlepos + vec]
		line.points = gpt_points
		update_collision()

func finds(i):
	return i == self
	
#func update_collision():
	#if collision_shape and start_box and end_box:
		#var shape = collision_shape.shape as CapsuleShape2D
		#var p1 : Vector2 =  line.points[0]
		#var p2 : Vector2 =  line.points[1]
		#shape.height = p1.distance_to(p2)
		#shape.radius = 15
		#collision_shape.global_position = (p1+p2)/2
		#collision_shape.rotation = atan2(p2.y-p1.y, p2.x-p1.x) - PI/2


func get_line_points(sb, eb, N: int, n: int) :
	var p1 = sb.middlepos
	var p2 = eb.middlepos
	var w1 = sb.size.x
	var h1 = sb.size.y
	var w2 = eb.size.x
	var h2 = eb.size.y
	var dir = (p2 - p1).normalized()
	var norm = Vector2(-dir.y, dir.x)
	
	var lim1 = max_off(p1, w1, h1, norm)
	var lim2 = max_off(p2, w2, h2, norm)
	var lim3 = max_off(p1, w1, h1, -norm)
	var lim4 = max_off(p2, w2, h2, -norm)
	var min_pos = min(lim1, lim2) * 0.9
	var min_neg = min(lim3, lim4) * 0.9
	var t = 0.0 if N == 1 else n / float(N - 1)
	var offset = norm * lerp(-min_neg, min_pos, t)
	return [p1 + offset, p2 + offset]
	
func max_off(p: Vector2, w: float, h: float, v: Vector2) -> float:
		var dx = v.dot(Vector2(1, 0))
		var dy = v.dot(Vector2(0, 1))
		var tx = INF if dx == 0 else abs((w / 2) / dx)
		var ty = INF if dy == 0 else abs((h / 2) / dy)
		return min(tx, ty)

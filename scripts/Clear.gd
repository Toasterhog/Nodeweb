extends Button

var delt := 0.0
@onready var box_holder: Node2D = $"../../../../papper/boxHolder"
@onready var bundle_holder: Node2D = $"../../../../papper/bundleHolder"

func _on_button_up() -> void:
	$"../../../ConfirmationDialog".popup()

func _on_confirmation_dialog_confirmed() -> void:
	var ca = box_holder.get_child_count()
	var bun_cnt = bundle_holder.get_child_count()
	delt = 2.0 / (ca + bun_cnt)
	delt = minf(delt, 0.16)
	
	var t =  get_tree().create_tween().set_parallel()
	for i in ca:
		var c : BoxClass = box_holder.get_child(i)
		c.pivot_offset = c.size / 2
		t.tween_property(c, "scale", Vector2(0.1, 2.5), 0.3).set_delay(delt * i).set_custom_interpolator(ci)
		t.tween_callback(c.queue_free).set_delay(delt * i + 0.3)
	

	
	for i in bun_cnt:
		var bun = bundle_holder.get_child(i)
		#t.tween_callback(bun.delete_self).set_delay(delt*ca + delt * i)
		const endsiz := Vector2(0.1, 1.3)
		var siz : Vector2 = bun.get_node("Panel").size
		var posoff : Vector2 = Vector2((1 - endsiz.x)/2, (1 - endsiz.y)/2 ) * siz
		
		t.tween_property(bun, "scale", endsiz, 0.3).set_delay(delt*ca + delt * i).set_custom_interpolator(ci)
		t.tween_property(bun, "position", posoff + bun.global_position, 0.3).set_delay(delt*ca + delt * i).set_custom_interpolator(ci)
		t.tween_callback(bun.queue_free).set_delay(delt*ca + delt * i + 0.3)
		
		
	
func ci(v):
	return curve.sample_baked(v)
	
@export var curve : Curve

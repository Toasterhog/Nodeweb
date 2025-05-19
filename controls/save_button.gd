extends Button



func _on_save_dialog_button_animate() -> void:
	pivot_offset = size/2
	var twn = get_tree().create_tween().set_parallel()
	twn.tween_property(self, "modulate", Color.LIME_GREEN, 0.4).set_trans(Tween.TRANS_CUBIC)
	twn.tween_property(self, "scale", Vector2(1.1, 1.1), 0.4).set_trans(Tween.TRANS_CUBIC)
	
	twn.tween_property(self, "rotation", -0.5, 0.8).from(0.5).set_custom_interpolator(ci)
	
	
	twn.tween_property(self, "scale", Vector2(1,1), 0.4).set_trans(Tween.TRANS_QUART).set_delay(0.4)
	twn.tween_property(self, "modulate", Color.WHITE, 0.4).set_trans(Tween.TRANS_QUART).set_delay(0.4)
	twn.chain().tween_property(self, "rotation", 0, 0)
	
func ci(v):
	return cur.sample_baked(v)
@export var cur : Curve

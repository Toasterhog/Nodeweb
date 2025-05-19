extends Button

var time := 0.0
var delt := 0.0
@onready var box_holder: Node2D = $"../../../../papper/boxHolder"

func _on_button_up() -> void:
	$"../../../ConfirmationDialog".popup()

func _on_confirmation_dialog_confirmed() -> void:
	var ca = box_holder.get_child_count()
	delt = 2.0 / ca
	delt = minf(delt, 0.16)
	
	var t =  get_tree().create_tween().set_parallel()
	for i in ca:
		var c : BoxClass = box_holder.get_child(i)
		c.pivot_offset = c.size / 2
		t.tween_property(c, "scale", Vector2(0.1, 2.5), 0.3).set_delay(delt * i).set_custom_interpolator(ci)
		t.tween_callback(c.queue_free).set_delay(delt * i + 0.3)
		
func ci(v):
	return curve.sample_baked(v)
	
@export var curve : Curve

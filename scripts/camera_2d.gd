extends Camera2D

var target_zoom := 1.0
var max_zoom := 5  # furthest in
var min_zoom := 0.3  #furthest out
var delta_zoom := 0.3 #sensitivity / differance per wheel movement
var zoom_rate := 10  #speed to follow, lower = dragy and delayed
var viewport_size 
func _ready() -> void:
	viewport_size = get_viewport_rect().size
	#min_zoom = min((limit_right + abs(limit_left))/ viewport_size.x, (limit_bottom + abs(limit_top))/ viewport_size.y)
	


func _input(event: InputEvent) -> void: 
	if SettingsAndDataManager.OSmode == &"mac":
		mac_input(event)
	else:
		windows_input(event)
	
	
	
func windows_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			position -= event.relative / zoom 
			position = position.clamp(
				Vector2(
					limit_left + 0.5 * viewport_size.x/ zoom.x, 
					limit_top + 0.5 * viewport_size.y/ zoom.y), 
				Vector2(
					limit_right - 0.5 * viewport_size.x/ zoom.x ,
					limit_bottom - 0.5 * viewport_size.y/ zoom.y))
			
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()


func mac_input(event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_META):
		if event.is_action_pressed("ui_up", true):
			zoom_in()
		if event.is_action_pressed("ui_down", true):
			zoom_out()
	
	elif event is InputEventKey and (event.is_action_pressed("ui_left")
	or event.is_action_pressed("ui_right")
	or event.is_action_pressed("ui_up")
	or event.is_action_pressed("ui_down")):
		set_process(true)

		
func _process(delta: float) -> void:
	var direction : = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	position += direction * 7 / zoom 
	position = position.clamp(
		Vector2(
			limit_left + 0.5 * viewport_size.x/ zoom.x, 
			limit_top + 0.5 * viewport_size.y/ zoom.y), 
		Vector2(
			limit_right - 0.5 * viewport_size.x/ zoom.x ,
			limit_bottom - 0.5 * viewport_size.y/ zoom.y))
			
	if direction == Vector2.ZERO:
		set_process(false)


func zoom_out() -> void:
	target_zoom = max(target_zoom * (1- delta_zoom), min_zoom)
	set_physics_process(true)
	
func zoom_in() -> void:
	target_zoom = min(target_zoom *(1+delta_zoom), max_zoom)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp( zoom, target_zoom * Vector2.ONE, zoom_rate * delta )
	set_physics_process(not is_equal_approx(zoom.x, target_zoom))

extends PanelContainer

@onready var option_button_bacround: OptionButton = $VBoxContainerSettings/OptionButtonBackground
@onready var color_picker_backround: ColorPickerButton = $VBoxContainerSettings/ColorPickerBackround
@onready var camera: Camera2D = $"../../../papper/Camera2D"
@onready var background_grid: Sprite2D = $"../../../papper/background_grid"
@onready var background_mountains: Sprite2D = $"../../../papper/background_mountains"
var current_background

func _ready() -> void:
	current_background = background_grid
	#set_process(false)
	color_picker_backround.color = RenderingServer.get_default_clear_color()

func _process(delta: float) -> void:
	current_background.position = camera.position * 0.6

func _on_settings_pressed() -> void:
	visible = not visible #the settings panel

func _on_option_button_background_item_selected(index: int) -> void:
	match index:
		0:
			set_bg(background_grid)
		1:
			set_bg(background_mountains)
		_:
			set_bg(null)

func set_bg(canv_or_null):
	if current_background:
		current_background.hide()
	if canv_or_null is Sprite2D:
		current_background = canv_or_null
		current_background.show()
		set_process(true)
		print(canv_or_null)
	else:
		current_background = null
		set_process(false)

func _on_color_picker_backround_button_down() -> void:
	if current_background:
		set_bg(null)
		option_button_bacround.select(2)

func _on_color_picker_backround_color_changed(color: Color) -> void:
	RenderingServer.set_default_clear_color(color)

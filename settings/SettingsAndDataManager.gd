extends Node

const CRPL = preload("uid://dib5k6nd1co0j")

@onready var tool_add_box_: tool_add_box = $"../state_machine_tools/tool_add_box"
@onready var color_picker_button: ColorPickerButton = $"../CanvasLayer/VBoxContainer/HBoxContainer2/ColorPickerButton"
@onready var cp : ColorPicker = color_picker_button.get_picker()

func _ready() -> void:
	var OSmode
	match OS.get_name():
		"Windows":
			OSmode = &"windows"
		"macOS":
			OSmode = &"mac"
		_:
			OSmode = &"windows"
	IdManager.OSmode = OSmode
	
	get_tree().set_auto_accept_quit(false)
	load_swatches()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		about_to_quit()
		get_tree().quit() # default behavior

func about_to_quit() -> void:
	var CR = CRPL.duplicate()
	CR.def_color = tool_add_box_.default_color
	CR.swatches = cp.get_presets()
	ResourceSaver.save(CR, "user://SettingsAndData.tres")


func load_swatches() -> void:
	var path = "user://SettingsAndData.tres"
	if ResourceLoader.exists(path):
		var res : ConfigRes = ResourceLoader.load(path)
		var swatches = res.swatches
		for swatch in swatches:
			cp.add_preset(swatch) #wtfffffffffff
			print(cp.get_presets())
		#cp.set_pick_color(res.def_color)
		color_picker_button.color = res.def_color
		$"../state_machine_tools"._on_color_picker_button_popup_closed()
	

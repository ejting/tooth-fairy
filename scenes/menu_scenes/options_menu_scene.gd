extends Control

@onready var input_button_scene = preload("res://scenes/menu_scenes/action_remap_button.tscn")
@onready var keybind_list = $VBoxContainer/OptionsPanel/PanelMargins/OptionScroller/OptionMargins/OptionSettings/KeybindSettings
@onready var option_list = $VBoxContainer/OptionsPanel/PanelMargins/OptionScroller/OptionMargins/OptionSettings

var is_remapping = false
var action_to_remap = null
var remapping_button = null


var input_actions = {
	"forward": "Move Forward",
	"backward": "Move Backward",
	"left": "Move Left",
	"right": "Move Right",
	"sprint": "Sprint",
	"interact": "Interact"
}


func _ready():
	_create_action_list()


func _create_action_list():
	InputMap.load_from_project_settings()
	for item in keybind_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("ButtonLabel")
		var input_label = button.find_child("KeyLabel")
		
		action_label.text = input_actions[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		keybind_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("KeyLabel").text = "Press Key to Bind"

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey || 
			(event is InputEventMouseButton && event.pressed)
		):
			#make double click into single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button, event):
	button.find_child("KeyLabel").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_keybinds_pressed() -> void:
	_create_action_list()


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value / 5)
	option_list.find_child("VolumeAdjustor").find_child("VolumeValue").text = " " + str(value)


#func _on_brightness_value_changed(value: float) -> void:
#	Environment.set_adjustment_brightness(value / 50)
#	option_list.find_child("BrightnessAdjustor").find_child("BrightnessValue").text = " " + str(value)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu_scene.tscn")

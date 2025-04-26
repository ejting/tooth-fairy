extends Control


func _ready():
	ResourceLoader.load_threaded_request(Globals.target_scene_path)
	Globals.load_requested = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/exposition_screen0.tscn")



func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options_menu_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()

extends Control


func _ready():
	ResourceLoader.load_threaded_request(Globals.target_scene_path)
	Globals.load_requested = true


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/loading_screen.tscn")



func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options_menu_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()

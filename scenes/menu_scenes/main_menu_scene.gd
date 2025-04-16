extends Control

const PLAY_SCENE_PATH = "res://scenes/dentist_building_scene.tscn"

func _ready():
	ResourceLoader.load_threaded_request(PLAY_SCENE_PATH)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/loading_screen.tscn")



func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options_menu_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()

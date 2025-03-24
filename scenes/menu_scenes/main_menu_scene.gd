extends Control



#func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/first_scene.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options_menu_scene.tscn")


func _on_quit_pressed():
	get_tree().quit()

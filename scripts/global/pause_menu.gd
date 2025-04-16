extends Control

func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scenes/options_menu_scene.tscn")



func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scenes/main_menu_scene.tscn")

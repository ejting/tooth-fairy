extends Control

@export var title: String
@export var text_content: Array[String]
@export var next_scene: String
@onready var title_label = $PanelContainer/MarginContainer/VBoxContainer/Title
@onready var text_body = $"PanelContainer/MarginContainer/VBoxContainer/Text Body"

var text_index: int = 0

func _ready():
	text_body.text = text_content[text_index]
	title_label.text = title
	if !Globals.load_requested:
		ResourceLoader.load_threaded_request(Globals.target_scene_path)
		Globals.load_requested = true

func _process(delta):
	if (Input.is_action_just_pressed("interact")):
		text_index += 1
		if(text_index >= text_content.size()):
			get_tree().change_scene_to_file(next_scene)
		else:
			text_body.text = text_content[text_index]

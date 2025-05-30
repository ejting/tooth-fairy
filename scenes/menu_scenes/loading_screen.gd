extends Control


var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $MarginContainer/VBoxContainer/ProgressBar

func _ready():
	if (!Globals.load_requested):
		ResourceLoader.load_threaded_request(Globals.target_scene_path)

func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(Globals.target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			Globals.load_requested = false
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(Globals.target_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")

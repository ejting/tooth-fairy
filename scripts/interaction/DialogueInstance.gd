class_name DialogueInstance extends Resource

@export var name : String ## The name of the current speaker
@export var self_thought : bool ## Tick this box to have this be a "self thought"
@export_multiline var line : String ## The line of dialogue
@export_enum("Default", "Main") var voice_line : int ## Will change the voiceline if different
@export_range(0.0, 2.0, 0.01) var dialouge_speed : float = 1.0

func get_speaker():
	return name if !self_thought else "ME"

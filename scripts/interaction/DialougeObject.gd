class_name DialogueObject extends Resource

@export_placeholder("(Optional)") var description : String
@export_group("Dialogue Options")
@export_multiline var dialogue : Array[String]
@export_enum("Main") var voice_line : int
@export_range(0.0, 2.0, 0.01) var dialouge_speed : float = 1.0

@export_group("Response Options")
@export var response_options_available : bool = false
@export_multiline var response_button_titles : Array[String]

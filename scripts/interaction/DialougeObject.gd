class_name DialogueObject extends Resource

@export_placeholder("(Optional)") var description : String
@export_group("Dialogue Options")
@export var dialogue : Array[DialogueInstance]

@export_group("Response Options")
@export var response_options_available : bool = false
@export_multiline var response_button_titles : Array[String]

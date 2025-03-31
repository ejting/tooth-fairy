class_name DialogueObject extends Resource

@export_placeholder("(Optional)") var description : String
@export_group("Dialogue Options")
@export_multiline var dialogue : Array[String]
@export_enum("Main") var voice_line : int
@export_range(0.0, 2.0, 0.1) var dialouge_speed : float = 1.0

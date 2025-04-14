class_name Interactable extends Node3D

@export_category("Interactable Properties")
@export var inter_name : String
@export var self_thought : bool

@export_category("Dialogue Objects")
@export var dialogue_objects : Array[DialogueObject]

# Index of the dialogue, specifically for the objects
var dialogue_index : int = 0
# Index for each line in that dialogue object
var line_index : int = 0
# A quick access variable for whether or not this object has response options
var has_response_options : bool = false

## This function will be called when interacted with
func on_interact(dm_ref : DialogueManager):
	Globals.in_dialogue = true

func stop_interact():
	Globals.in_dialogue = false

func finished_dialouge(dm_ref : DialogueManager):
	pass

func set_interact_label_text(interact_label_ref : Label):
	interact_label_ref.text = "Press [F] to interact"

## Able to be overridden to make options do something other than close the prompt
func option_selected(dm_ref : DialogueManager, which : int):
	dm_ref.finish_message()

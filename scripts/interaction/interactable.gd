class_name Interactable extends Node3D

@export_category("Interactable Properties")
@export var inter_name : String

@export_category("Dialogue Objects")
@export var dialogue_objects : Array[DialogueObject]


## This function will be called when interacted with
func on_interact(dm_ref : DialogueManager):
	Globals.in_dialogue = true

func stop_interact():
	Globals.in_dialogue = false

func finished_dialouge(dm_ref : DialogueManager):
	pass

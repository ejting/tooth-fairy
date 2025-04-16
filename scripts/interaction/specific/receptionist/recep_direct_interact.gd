extends Interactable

@export var to_look_at_obj : Node3D

func on_interact(dm_ref : DialogueManager):
	super(dm_ref)
	# Reset our line index position
	line_index = 0
	dm_ref.reset(self)
	dm_ref.lock_down_player()
	dm_ref.force_player_to_look_at(to_look_at_obj)
	# Type out the message
	dm_ref.type_message(dialogue_objects[dialogue_index].dialogue[line_index])

func finished_dialouge(dm_ref : DialogueManager):
	line_index += 1
	if(dialogue_objects[dialogue_index].dialogue.size() <= line_index):
		# done with dialogue
		dm_ref.free_player()
		stop_interact()
	else:
		dm_ref.type_message(dialogue_objects[dialogue_index].dialogue[line_index])

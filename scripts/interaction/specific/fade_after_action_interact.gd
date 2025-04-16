class_name BlackoutAfterInteract extends Interactable

func on_interact(dm_ref : DialogueManager):
	# failsafe
	if(dialogue_objects.size() <= 0):
		return
	super(dm_ref)
	# Reset our line index position
	line_index = 0
	dm_ref.reset(self)
	dm_ref.lock_down_player()
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

func option_selected(dm_ref : DialogueManager, which : int):
	dm_ref.blackout()

func blackout_finished(dm_ref : DialogueManager):
	# Play sound
	preform_blacked_out_action(dm_ref)
	
func preform_blacked_out_action(dm_ref : DialogueManager):
	dm_ref.wait_for_time(1.0)
		
func blackout_timer_finished(dm_ref : DialogueManager):
	# Move the cabinet
	dm_ref.unblackout()

func unblackout_finished(dm_ref : DialogueManager):
	preform_unblacked_out_action(dm_ref)

func preform_unblacked_out_action(dm_ref : DialogueManager):
	dm_ref.finish_message()

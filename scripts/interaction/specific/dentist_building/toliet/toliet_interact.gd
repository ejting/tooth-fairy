extends BlackoutAfterInteract

@export var wait_time_after_blackout : float = 1.0

func option_selected(dm_ref : DialogueManager, which : int):
	if(which == 0):
		dm_ref.blackout()
	else:
		dm_ref.free_player()
		stop_interact()

func preform_blacked_out_action(dm_ref : DialogueManager):
	dm_ref.wait_for_time(0.25)
	
func preform_unblacked_out_action(dm_ref : DialogueManager):
	dm_ref.finish_message()

extends Interactable

func on_interact(dm_ref : DialogueManager):
	super(dm_ref)
	dm_ref.reset(self)
	dm_ref.lock_down_player()

func finished_dialouge(dm_ref : DialogueManager):
	print("Finished")
	dm_ref.free_player()
	stop_interact()

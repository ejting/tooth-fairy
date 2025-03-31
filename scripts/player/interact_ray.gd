class_name InteractRay extends RayCast3D

@export var interact_label : Label
@export var dm_ref : DialogueManager

var interacting : bool = false;

func _process(delta):
	if(!Globals.in_dialogue && is_colliding()):
		interact_label.visible = true
		interacting = true
	else:
		interact_label.visible = false
		interacting = false
		
func _unhandled_input(event):
	if(!Globals.in_dialogue && event.is_action_pressed("interact") && interacting):
		var the_obj = get_collider()
		if(the_obj.has_method("on_interact")):
			the_obj.on_interact(dm_ref)

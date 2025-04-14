class_name InteractRay extends RayCast3D

@export var interact_label : Label
@export var dm_ref : DialogueManager

var interacting : bool = false;
var bitMaskWall = 1 << 2
var bitMaskInteract = 1 << 3

func _process(delta):
	## Do not check for interations if we collided with a wall
	if(is_colliding() && is_wall()):
		interact_label.visible = false
		interacting = false
		return
	if(!Globals.in_dialogue && is_colliding()):
		if(get_collider() is Interactable):
			get_collider().set_interact_label_text(interact_label)
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

# checks if this thing is just a wall (if its interactable, it's not just a wall)
func is_wall():
	return (get_collider().get_collision_layer() & bitMaskWall) == bitMaskWall && (get_collider().get_collision_layer() & bitMaskInteract) != bitMaskInteract

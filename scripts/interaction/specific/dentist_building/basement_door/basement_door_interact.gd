extends Interactable

var opened : bool = false
var changing_states : int = 0
var snap_margin : float = 0.5
@export var to_rotate : Node3D
@export var to_match_rotate : Node3D
@export var DOOR_OPEN_ROTATION : float = -128.0
@export var FLAT_ADDITION : float = 0
@export var DOOR_CLOSE_ROTATION : float = 0
@export var DOOR_OPENING_SPEED : float = 10.0

# These refs will be needed to move the building up, so the stairs are accessible
@export var entire_building_ref : Node3D
@export var player_ref : Player
var saved_building_y : float
var saved_player_y : float
var flat_increase : float = 50.0

var personal_dm_ref : DialogueManager

func on_interact(dm_ref : DialogueManager):
	if(personal_dm_ref == null):
		personal_dm_ref = dm_ref
	if(changing_states == 0):
		super(dm_ref)
		if(opened):
			# Closing the door
			changing_states = -1
			move_all_down()
		else:
			# Opening the door
			changing_states = 1
			move_all_up()
		# Clear the interact text
		dm_ref.interact_label.text = ""
		# Starts the cooldown that will re-enable the interact
		# After the timer stops
		dm_ref.start_cooldown(stop_interact)

			

func finished_dialouge(dm_ref : DialogueManager):
	print("Finished")
	dm_ref.free_player()
	stop_interact()

func force_dm_update():
	# If we are still hovering over this door, then update the interaction label
	if(personal_dm_ref != null && personal_dm_ref.colliding_with_this(self)):
		set_interact_label_text(personal_dm_ref.interact_label)

func _process(delta):
	if(changing_states == -1):
		to_rotate.rotation_degrees.z = lerp(to_rotate.rotation_degrees.z, DOOR_CLOSE_ROTATION, delta * DOOR_OPENING_SPEED)
		if(abs(to_rotate.rotation_degrees.z) <= abs(DOOR_CLOSE_ROTATION - snap_margin)):
			changing_states = 0
			to_rotate.rotation_degrees.z = DOOR_CLOSE_ROTATION
			opened = false
			force_dm_update()
		#print("my rot: ", to_rotate.global_rotation_degrees, " and child's", self.global_rotation_degrees)
		#to_match_rotate.global_rotation_degrees.z = to_rotate.global_rotation_degrees.z
		to_match_rotate.rotation_degrees.z = to_rotate.rotation_degrees.z - get_parent().rotation_degrees.z + FLAT_ADDITION
		#to_match_rotate.global_rotation_degrees = to_rotate.global_rotation_degrees
		#print("my rot: ", to_rotate.rotation_degrees, " and child's", self.rotation_degrees)
	elif(changing_states == 1):
		to_rotate.rotation_degrees.z = lerp(to_rotate.rotation_degrees.z, DOOR_OPEN_ROTATION, delta * DOOR_OPENING_SPEED)
		if(abs(to_rotate.rotation_degrees.z) >= abs(DOOR_OPEN_ROTATION) - snap_margin):
			changing_states = 0
			to_rotate.rotation_degrees.z = DOOR_OPEN_ROTATION
			opened = true
			force_dm_update()
		to_match_rotate.rotation_degrees.z = to_rotate.rotation_degrees.z - get_parent().rotation_degrees.z + FLAT_ADDITION
		#o_match_rotate.global_rotation_degrees.z = to_rotate.global_rotation_degrees.z
		#to_match_rotate.global_rotation_degrees = to_rotate.global_rotation_degrees
		#print("my rot: ", to_rotate.rotation_degrees, " and child's", self.rotation_degrees)
		

func set_interact_label_text(interact_label_ref : Label):
	if(changing_states != 0):
		interact_label_ref.text = ""
	else:
		if(opened):
			interact_label_ref.text = "Press [F] to close door"
		else:
			interact_label_ref.text = "Press [F] to open door"

func move_all_up():
	saved_building_y = entire_building_ref.position.y
	saved_player_y = player_ref.position.y
	entire_building_ref.position.y += flat_increase
	player_ref.position.y += flat_increase
	# Enable the collisions

func move_all_down():
	entire_building_ref.position.y -= flat_increase
	player_ref.position.y -= flat_increase
	# Disable the collisions
	

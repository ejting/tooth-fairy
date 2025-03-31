class_name DialogueManager extends Control

@export var player_ref : Player

@export var labels : Array[Label]
@export_range(0, 0.5, 0.001) var delay_time : float = 0.025
@export var informative_label : Label
var label_index : int = 0

var accum_time : float = 0.0
var message : String
var message_length : int
var current_progress : int
var typing : bool
var resolved : bool

# Other booleans for checking if we
#	1. encountered punctuation
#	2. encountered a specific character to change our text
## was punctuation
var punc : String = ".!?"
var was_punc : bool
var punc_delay_time : float

var ref : Interactable

func lock_down_player():
	player_ref.locked_in_dialogue = true
	
func free_player():
	#print("player has been freed")
	player_ref.locked_in_dialogue = false

func reset(ref : Interactable):
	resolved = false
	self.ref = ref
	# clear all label messages
	for x in range(labels.size()):
		labels[x].text = ""

func type_message(message_to_type : String, speed: float = 0.025):
	# Show this
	resolved = false
	informative_label.hide()
	show()
	delay_time = speed
	punc_delay_time = 0.25
	accum_time = 0.0
	message = message_to_type
	message_length = message.length()
	current_progress = 0;
	typing = true
	
func finish_message():
	hide()
	resolved = true
	## Tells the reference interactable that they can continue now
	ref.finished_dialouge(self)

func _process(delta) -> void:
	if(typing):
		if(Input.is_action_just_pressed("spacebar")):
			#we're skipping all of the dialogue now
			current_progress = message_length
			labels[label_index].text = message
		if(current_progress >= message_length):
			typing = false
			informative_label.show()
		else:
			accum_time += delta
			if(accum_time >= (punc_delay_time if was_punc else delay_time)):
				if(was_punc):
					was_punc = false
				if(punc.contains(message[current_progress])):
					was_punc = true
				current_progress += 1
				labels[label_index].text = message.substr(0, current_progress)
				accum_time = 0
	elif(!resolved):
		if(Input.is_action_just_pressed("spacebar")):
			finish_message()
		

class_name DialogueManager extends Control

@export var player_ref : Player
@export var interact_ray : InteractRay
@export var labels : Array[Label]
@export_range(0, 0.5, 0.001) var delay_time : float = 0.025
@export var informative_label : Label
@export var name_label : Label
@export var interact_label : Label
@export var cooldown_timer : Timer

@export var button_holder : VBoxContainer

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
var button_options_displayed : bool

func _ready():
	informative_label.hide()
	hide()
	change_font_size()
	
func change_font_size():
	var window_width = get_viewport().size.x
	var dialouge_window_size = (window_width / 7.4)
	size.y = dialouge_window_size
	#position.y = 648 - dialouge_window_size
	var font_size = window_width / 63
	print("The font size is ", font_size)
	interact_label.add_theme_font_size_override("font_size", font_size)
	name_label.add_theme_font_size_override("font_size", font_size)
	informative_label.add_theme_font_size_override("font_size", font_size)
	for i in range(labels.size()):
		labels[i].add_theme_font_size_override("font_size", font_size)

func start_cooldown(func_call : Callable, cooldown_time : float = 0.2):
	cooldown_timer.timeout.connect(_timer_remove_all_signal.bind(func_call))
	cooldown_timer.timeout.connect(func_call)
	cooldown_timer.start(cooldown_time)

func _timer_remove_all_signal(func_call : Callable):
	cooldown_timer.timeout.disconnect(func_call)
	cooldown_timer.timeout.disconnect(_timer_remove_all_signal)

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

## Check if the thing colliding matches
func colliding_with_this(which : Node3D) -> bool:
	if(interact_ray.is_colliding()):
		return interact_ray.get_collider().name == which.name
	return false

func type_message(message_to_type : String, speed: float = 0.025):
	# Show this
	# Set up the name of the obj
	if(ref != null):
		if(ref.self_thought):
			name_label.text = "[Me]"
		else:
			name_label.text = "[" + ref.inter_name + "]"
	
	resolved = false
	informative_label.hide()
	show()
	was_punc = false
	delay_time = speed
	punc_delay_time = 0.25
	accum_time = punc_delay_time if punc_delay_time > delay_time else delay_time
	message = message_to_type
	message_length = message.length()
	current_progress = 0
	typing = true
	
func finish_message():
	hide()
	resolved = true
	## Tells the reference interactable that they can continue now
	if(ref != null && !button_options_displayed):
		ref.finished_dialouge(self)

func _process(delta) -> void:
	if(typing):
		if(Input.is_action_just_pressed("spacebar")):
			#we're skipping all of the dialogue now
			current_progress = message_length
			labels[label_index].text = message
		if(current_progress >= message_length):
			typing = false
			# We should also check here if we should show response options
			if(ref != null && has_dialogue_responses_enabled() && is_last_line()):
				display_button_options()
			else:
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
		if(Input.is_action_just_pressed("spacebar") && !button_options_displayed):
			finish_message()
	if(Input.is_action_just_pressed("spacebar")):
		change_font_size()

func is_last_line() -> bool:
	return ref != null && ref.dialogue_objects[ref.dialogue_index].dialogue.size() - 1 == ref.line_index

func has_dialogue_responses_enabled() -> bool:
	return ref.dialogue_objects[ref.dialogue_index].response_options_available

func display_button_options():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	button_options_displayed = true
	var response_titles : Array[String] = ref.dialogue_objects[ref.dialogue_index].response_button_titles
	for i in range(response_titles.size()):
		var foundButton = button_holder.get_child(i) as Button
		foundButton.text = response_titles[i]
		foundButton.show()
		
func hide_button_options():
	finish_message()
	# Hide the buttons
	for child in button_holder.get_children():
		child.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	button_options_displayed = false

func option_one_selected():
	hide_button_options()
	if(ref != null):
		ref.option_selected(self, 0)
	

func option_two_selected():
	hide_button_options()
	if(ref != null):
		ref.option_selected(self, 1)
	
	
func option_three_selected():
	hide_button_options()
	if(ref != null):
		ref.option_selected(self, 2)
	
	
func option_four_selected():
	hide_button_options()
	if(ref != null):
		ref.option_selected(self, 3)
	

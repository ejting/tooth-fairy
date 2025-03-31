# Player movement pulled from this tutorial: https://www.youtube.com/watch?v=A3HLeyaBCq4

# Sets up the name of this script to be referred to later
class_name Player extends CharacterBody3D

# Grabs the camera pivot reference
@export var camera_pivot : Node3D
@export var camera : Camera3D
@export var pixel_cam : Camera3D

@export var SENSITIVITY = 0.003

var speed
var current_speed = 0.0
var bob_frequency
var bob_amplitude
const SPRINT_SPEED = 5.0
const WALK_SPEED = 3.5
const LERP_SPEED = 5.0
const MIN_Y_HEAD_LOCK = deg_to_rad(-40)
const MAX_Y_HEAD_LOCK = deg_to_rad(60)

# Head bobbing
const BOB_SPRINT_FREQUENCY = 2.0
const BOB_SPRINT_AMPLITUDE = 0.04
const BOB_WALK_FREQUENCY = 2.0
const BOB_WALK_AMPLITUDE = 0.04
var t_bob = 0.0

var locked_in_dialogue : bool = false

# Grabs the gravity value from the project
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# On Project start, lock in the mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if(event is InputEventMouseMotion && !locked_in_dialogue):
		camera_pivot.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, MIN_Y_HEAD_LOCK, MAX_Y_HEAD_LOCK)

func _process(delta):
	pixel_cam.global_transform = camera.global_transform


# This will be called every frame
# to handle our player movement
func _physics_process(delta):
	if(locked_in_dialogue):
		return
	if(not is_on_floor()):
		# Smoothly makes the player fall
		velocity.y -= gravity * delta
	
	if(Input.is_action_pressed("sprint")):
		current_speed = lerp(current_speed, SPRINT_SPEED, delta * LERP_SPEED)
		bob_amplitude = BOB_SPRINT_AMPLITUDE
		bob_frequency = BOB_SPRINT_FREQUENCY
	else:
		current_speed = lerp(current_speed, WALK_SPEED, delta * LERP_SPEED)
		bob_amplitude = BOB_WALK_AMPLITUDE
		bob_frequency = BOB_WALK_FREQUENCY
	
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if (direction):
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 14.0)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 14.0)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = getHeadBob()
	move_and_slide()

func getHeadBob() -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(t_bob * bob_frequency) * bob_amplitude
	pos.x = cos(t_bob * bob_frequency / 2) * bob_amplitude
	return pos

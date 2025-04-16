# Player movement pulled from this tutorial: https://www.youtube.com/watch?v=A3HLeyaBCq4

# Sets up the name of this script to be referred to later
class_name Player extends CharacterBody3D

# Grabs the camera pivot reference
@export var smoothing_camera_node : Node3D
@export var camera_pivot : Node3D
@export var camera : Camera3D
@export var rotator : Node3D
@export var pixel_cam : Camera3D
@export var model : Node3D
@export var dm_ref : DialogueManager

@export var SENSITIVITY = 0.003

@export var stairs_ahead_raycast : RayCast3D
@export var stairs_below_raycast : RayCast3D

var speed
var current_speed = 0.0
var bob_frequency
var bob_amplitude
const SPRINT_SPEED = 5.0
const WALK_SPEED = 3.5
const LERP_SPEED = 5.0
const MIN_Y_HEAD_LOCK = deg_to_rad(-40)
const MAX_Y_HEAD_LOCK = deg_to_rad(60)

const MAX_STEP_HEIGHT := 0.5
var snapped_to_stairs_last_frame := false
var last_frame_was_on_floor = -INF

# Head bobbing
const BOB_SPRINT_FREQUENCY = 2.0
const BOB_SPRINT_AMPLITUDE = 0.04
const BOB_WALK_FREQUENCY = 2.0
const BOB_WALK_AMPLITUDE = 0.04
var t_bob = 0.0

var locked_in_dialogue : bool = false
var looking_at : bool = false
var look_at_obj : Node3D

# Grabs the gravity value from the project
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# On Project start, lock in the mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if(event is InputEventMouseMotion && !locked_in_dialogue):
		camera_pivot.rotate_y(-event.relative.x * SENSITIVITY)
		model.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, MIN_Y_HEAD_LOCK, MAX_Y_HEAD_LOCK)

func _process(delta):
	if(looking_at):
		var previous = camera_pivot.rotation.y
		var complete_dist = (camera_pivot.rotation.y - rotator.rotation.y) * 4.5
		camera_pivot.rotation.y = lerp(camera_pivot.rotation.y, rotator.rotation.y, delta * max(4.5, complete_dist))
		model.rotation.y = camera_pivot.rotation.y - deg_to_rad(180)
		camera.rotation.x = lerp(camera.rotation.x, rotator.rotation.x, delta * max(4.5, complete_dist))
		if(abs(camera_pivot.rotation.y - rotator.rotation.y) <= 0.015):
			camera_pivot.rotation.y = rotator.rotation.y
			model.rotation.y = rotator.rotation.y - deg_to_rad(180)
			camera.rotation.x = rotator.rotation.x
			looking_at = false
		## TODO make this rotation work
		#looking_at = false
		#var direction = (position - look_at_obj.position).normalized()
		#var dot_product = look_at_obj.global_transform.basis.z.dot(direction)
		#var angle = acos(dot_product)
		#var to_vec = Vector3(0, angle, 0)
		#camera.rotation = lerp(camera.rotation, camera.rotation + to_vec, delta * 0.1)
		#if(camera.rotation.distance_to(to_vec) <= 0.1):
			# stop rotating when we are looking at the thing
		#	camera.rotation = to_vec
		#	looking_at = false
	pixel_cam.global_transform = camera.global_transform


# This will be called every frame
# to handle our player movement
func _physics_process(delta):
	if(locked_in_dialogue):
		return
	
	
	
	if(not is_on_floor()):
		# Smoothly makes the player fall
		velocity.y -= gravity * delta
	else:
		last_frame_was_on_floor = Engine.get_physics_frames()
	
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
	if(!snap_up_stairs_check(delta)):
		move_and_slide()
		snap_down_to_stairs_check()
	
	slide_camera_smooth_back_to_origin(delta)

func getHeadBob() -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(t_bob * bob_frequency) * bob_amplitude
	pos.x = cos(t_bob * bob_frequency / 2) * bob_amplitude
	return pos

# tutorial used: https://www.youtube.com/watch?v=Tb-R3l0SQdc
func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

var saved_camera_global_pos = null
func save_camera_pos_for_smoothing():
	#if(saved_camera_global_pos == null):
	#	saved_camera_global_pos = smoothing_camera_node.global_position
	pass

func look_at_given_pos(to_look_at : Node3D):
	look_at_obj = to_look_at
	looking_at = true
	# Look at this
	rotator.look_at(to_look_at.global_transform.origin, Vector3.UP)
	
func slide_camera_smooth_back_to_origin(delta):
	if(saved_camera_global_pos == null):
		return
	smoothing_camera_node.global_position.y = saved_camera_global_pos.y
	smoothing_camera_node.position.y = clampf(smoothing_camera_node.position.y, -0.7, 0.7)
	var move_amount = max(velocity.length() * delta, current_speed/2 * delta)
	smoothing_camera_node.position.y = move_toward(smoothing_camera_node.position.y, 0.0, move_amount)
	saved_camera_global_pos = smoothing_camera_node.global_position
	if(smoothing_camera_node.position.y == 0):
		saved_camera_global_pos = null
	

func run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below : bool = stairs_below_raycast.is_colliding() && !is_surface_too_steep(stairs_below_raycast.get_collision_normal())
	var was_on_the_floor_last_frame = Engine.get_physics_frames() - last_frame_was_on_floor == 1
	if(!is_on_floor() && floor_below && velocity.y <= 0 && (was_on_the_floor_last_frame || snapped_to_stairs_last_frame)):
		var body_test_result = PhysicsTestMotionResult3D.new()
		if(run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result)):
			save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	snapped_to_stairs_last_frame = did_snap

func snap_up_stairs_check(delta) -> bool:
	if(!is_on_floor() && !snapped_to_stairs_last_frame):
		return false
	var expected_move_motion = self.velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	var down_check_result = PhysicsTestMotionResult3D.new()
	if(run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") || down_check_result.get_collider().is_class("CSCShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		
		if(step_height > MAX_STEP_HEIGHT || step_height <= 0.01 || (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT):
			return false
		stairs_ahead_raycast.global_position = down_check_result.get_collision_point() * Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		stairs_ahead_raycast.force_raycast_update()
		if(stairs_ahead_raycast.is_colliding() && !is_surface_too_steep(stairs_ahead_raycast.get_collision_normal())):
			save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			snapped_to_stairs_last_frame = true
			return true
	return false

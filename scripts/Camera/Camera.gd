class_name FreeLookCamera extends Camera3D

# Modifier keys' speed multiplier
const SHIFT_MULTIPLIER = 2.5
const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER


@export_range(0.0, 1.0) var sensitivity: float = 0.5

# Mouse state
var _mouse_position = Vector2(0.0, 0.0)

var _acceleration = 30
var _vel_multiplier = 4
var _lookaround = false

var _reference_pos = Vector3()
var _base_angle = Vector3(30, 180, 0)
var _reference_angle = _base_angle

var _velocity = Vector3()
var _omega = Vector3()
var _pos_epsilon = Vector3()
var _angle_epsilon = Vector3()


func get_ideal_cam_transform():
	get_parent().global_transform.origin + get_player_cam_reference_offset()
	var z_offset = cos(deg_to_rad(_base_angle[0])) * get_parent().distance_to_character
	var y_offset = sin(deg_to_rad(_base_angle[0])) * get_parent().distance_to_character
	#offset along basis
	var offset = Vector3(0, y_offset, -z_offset)
	var basis = Basis().looking_at(get_parent().global_transform.origin, Vector3(0, 1, 0))
	
func get_player_cam_reference_offset():
	var z_offset = cos(deg_to_rad(_base_angle[0])) * get_parent().distance_to_character
	var y_offset = sin(deg_to_rad(_base_angle[0])) * get_parent().distance_to_character
	return Vector3(0, y_offset, -z_offset)


func angle_pid(target, current, delta):
	var kp = 1.0
	var ki = 0.1
	var kd = 0.0
	var error = target - current
	var integral = error * delta
	var derivative = (error - _angle_epsilon) / delta
	_angle_epsilon = error
	return kp * error + ki * integral + kd * derivative


func _ready():
	# Set the mouse mode to captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#set_as_top_level(true)
	#var p_origin = get_node("../..").global_transform.origin

	#global_transform.origin = p_origin + get_player_cam_reference_offset()
	#Basis().looking_at(p_origin, Vector3(0, 1, 0))
	#_reference_angle = Basis().get_euler()


func _input(event):

	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
	print(_mouse_position)

# Updates mouselook and movement every frame
func _process(delta):

	# Get the mouse look offset
	var lookaround = get_lookaround_angle_offset()

# Updates mouse look 
func get_lookaround_angle_offset():
	# Only rotates mouse if the mouse is captured
	#if _lookaround:
	_mouse_position *= sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	pitch = clamp(pitch, -89, 89)
	yaw = fmod(yaw, 360)
		#print pitch yaw
		# print(Vector3(pitch, yaw, 0))


	return Vector3(pitch, yaw, 0)


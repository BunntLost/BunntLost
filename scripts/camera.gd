class_name FreeLookCamera extends Camera3D

# Modifier keys' speed multiplier
const SHIFT_MULTIPLIER = 2.5
const ALT_MULTIPLIER = 1.0 / SHIFT_MULTIPLIER


@export_range(0.0, 1.0) var sensitivity: float = 0.25

# Mouse state
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

var distance_to_character = 5.0

var _acceleration = 30
var _deceleration = -10
var _vel_multiplier = 4
var _lookaround = false

var _reference_pos = Vector3()
var _reference_angle = Vector3(30, 180, 0)

var _velocity = Vector3()
var _omega = Vector3()
var _pos_epsilon = Vector3()
var _angle_epsilon = Vector3()


func get_player_cam_reference_offset():
	var z_offset = cos(deg_to_rad(_reference_angle[0])) * distance_to_character
	var y_offset = sin(deg_to_rad(_reference_angle[0])) * distance_to_character
	return Vector3(0, y_offset, -z_offset)

func position_pid(target, current, delta):
	var kp = 0.1
	var ki = 0.1
	var kd = 0.1
	var error = target - current
	var integral = error * delta
	var derivative = (error - _pos_epsilon) / delta
	_pos_epsilon = error
	return kp * error + ki * integral + kd * derivative

func angle_pid(target, current, delta):
	var kp = 0.1
	var ki = 0.1
	var kd = 0.1
	var error = target - current
	var integral = error * delta
	var derivative = (error - _angle_epsilon) / delta
	_angle_epsilon = error
	return kp * error + ki * integral + kd * derivative

func get_looking_at_angle():
	var looking_at = get_parent().global_transform.origin
	var direction = looking_at - global_transform.origin
	var yaw = atan2(direction.x, direction.z)
	var pitch = atan2(direction.y, sqrt(direction.x * direction.x + direction.z * direction.z))
	return Vector3(rad_to_deg(pitch), rad_to_deg(yaw), 0)

func _ready():
	# Set the mouse mode to captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var p_origin = get_parent().global_transform.origin

	global_transform.origin = p_origin + get_player_cam_reference_offset()
	Basis().looking_at(p_origin, Vector3(0, 1, 0))
	_reference_angle = Basis().get_euler()


func _input(event):

	#get position of parent node

	#check scroll wheel
	_lookaround = Input.is_action_pressed("lookaround")
	
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
	
	# Receives mouse button input
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT: # Only allows rotation if right click down
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # Increases max velocity
				_vel_multiplier = clamp(_vel_multiplier * 1.1, 0.2, 20)
			MOUSE_BUTTON_WHEEL_DOWN: # Decereases max velocity
				_vel_multiplier = clamp(_vel_multiplier / 1.1, 0.2, 20)

# Updates mouselook and movement every frame
func _process(delta):


	_reference_pos = get_parent().global_transform.origin + get_player_cam_reference_offset()
	_reference_angle = get_looking_at_angle() + get_lookaround_angle_offset()

	global_transform.origin = position_pid(_reference_pos, global_transform.origin, delta)


# Updates mouse look 
func get_lookaround_angle_offset():
	# Only rotates mouse if the mouse is captured
	if _lookaround:
		_mouse_position *= sensitivity
		var yaw = _mouse_position.x
		var pitch = _mouse_position.y
		pitch = clamp(pitch, -89, 89)
		yaw = fmod(yaw, 360)
		#print pitch yaw
		# print(Vector3(pitch, yaw, 0))


		return Vector3(pitch, yaw, 0)
	else:
		return Vector3(0, 0, 0)

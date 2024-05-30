extends Node3D
var _pos_epsilon = Vector3()
var _velocity = Vector3()
func position_pid(target, current, delta):
	var kp = 0.5
	var ki = 0.1
	var kd = 0.1
	var error = target - current
	var integral = error * delta
	var derivative = (error - _pos_epsilon) / delta
	_pos_epsilon = error
	return kp * error + ki * integral + kd * derivative

# Called when the node enters the scene tree for the first time.
func _ready():
	global_transform.origin = get_parent().global_transform.origin
	set_as_top_level(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_velocity += position_pid(get_parent().global_transform.origin, global_transform.origin, delta)
	global_transform.origin += _velocity*delta
	pass

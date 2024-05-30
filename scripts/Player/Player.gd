extends CharacterBody3D

var vibe_strength = 5
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var anim_player
var is_moving = false
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		transform.basis = transform.basis.rotated(Vector3(0, 1, 0), -event.relative.x * 0.01)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var input_dir = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	# get a, d, s, w
	var input_dir = Input.get_vector("move_right", "move_left", "move_backward", "move_forward")

	is_moving = input_dir.length() > 0

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#update global transform
	#global_transform.origin += velocity * delta
	move_and_slide()

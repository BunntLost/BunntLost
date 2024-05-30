extends MeshInstance3D

var t = 0.0
var relative_transform
# Called when the node enters the scene tree for the first time.
func _ready():
	relative_transform = transform
	#set_as_top_level(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().is_moving:
		var v = get_parent().get_velocity().length()
		t += v*get_parent().vibe_strength
		transform.origin.y = relative_transform.origin.y + 0.05*sin(t)
	pass

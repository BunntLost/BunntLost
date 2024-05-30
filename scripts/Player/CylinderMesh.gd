extends MeshInstance3D

var t = 0.0
var nose_length
# Called when the node enters the scene tree for the first time.
func _ready():
	#set_as_top_level(true)
	nose_length = mesh.height
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().is_moving:
		var v = get_parent().get_velocity().length()
		t += v*get_parent().vibe_strength
		mesh.height = nose_length*(1 + 0.2*sin(t))
	pass

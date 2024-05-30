extends MeshInstance3D

var vibe_offset = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.material.set_shader_parameter("vibe_offset", vibe_offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var v = get_parent().get_velocity().length()
	#access material of meshinstance
	# var material = get_surface_material(0)
	vibe_offset += delta*v*get_parent().vibe_strength
	mesh.material.set_shader_parameter("vibe_offset", vibe_offset)


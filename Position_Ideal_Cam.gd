extends Node3D


var distance_to_character = 5.0
var angle = Vector3(30, 180, 0)
var x = cos(angle[0])*distance_to_character
var y = sin(angle[0])*distance_to_character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

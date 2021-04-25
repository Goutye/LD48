extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var x = 0
export(float) var factor = 3
export(float) var max_angle = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	x += delta * factor
	rect_rotation = sin(x) * max_angle


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

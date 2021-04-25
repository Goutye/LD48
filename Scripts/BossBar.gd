extends Node2D

var max_value = 142

func _ready():
	$ProgressTexture.rect_scale.x = 0
	
func set_ratio(ratio):
	$ProgressTexture.rect_scale.x = clamp(ratio * max_value, 0, 142)

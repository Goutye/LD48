extends Node2D

var size = 14.0

func _ready():
	pass

func set_ratio(ratio : float):
	$Sprite/Sprite.scale.x = clamp(ratio * size, 0, size)

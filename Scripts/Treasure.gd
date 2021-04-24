extends Node2D

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

var player

func initialize(portion_id):
	pass

func on_body_entered(body):
	if body.get_parent() is Player:
		player = body.get_parent()
		player.start_ui()
		display_choices()

func display_choices():
	print("treasure")
	get_parent().remove_child(self)
	player.end_ui()

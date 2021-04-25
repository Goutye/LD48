extends Node2D

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

export(int) var rarity = 0
var portion_id
var player

func initialize(portion_id):
	self.portion_id = portion_id

func on_body_entered(body):
	if body.get_parent() is Player:
		player = body.get_parent()
		display_choices()

func display_choices():
	player.display_loots(portion_id, rarity, true)
	get_parent().remove_child(self)

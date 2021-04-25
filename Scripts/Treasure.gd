extends Node2D

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

export(int) var rarity = 0
var portion_id
var player
var is_displaying_options = false

func initialize(portion_id):
	self.portion_id = portion_id

func _process(delta):
	if is_displaying_options and not player.is_paused:
		get_parent().remove_child(self)

func on_body_entered(body):
	if body.get_parent() is Player:
		player = body.get_parent()
		display_choices()

func display_choices():
	$Area2D/AudioStreamPlayer2D.play()
	is_displaying_options = true
	player.display_loots(portion_id, rarity, true)

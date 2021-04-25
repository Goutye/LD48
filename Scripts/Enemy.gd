class_name Enemy
extends Character

signal on_fight_start(enemy)

export(int) var rarity = 0
export(bool) var hover = false

export(int) var factor = 2
export(int) var extent = 10
var time = 0

func _ready():
	$Body.connect("body_entered", self, "on_body_entered")
	

func _process(delta):
	if hover:
		time += delta * factor
		$Body/Body.position.y = sin(time) * extent

func on_body_entered(other_body):
	if other_body.get_parent() is Player:
		emit_signal("on_fight_start", self)

func play_death_anim():
	get_parent().remove_child(self)

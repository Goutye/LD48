extends Character

signal on_fight_start(enemy)

export(int) var rarity = 0

func _ready():
	$Body.connect("body_entered", self, "on_body_entered")

func on_body_entered(other_body):
	if other_body.get_parent() is Player:
		emit_signal("on_fight_start", self)

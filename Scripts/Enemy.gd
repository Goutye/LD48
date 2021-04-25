class_name Enemy
extends Character

signal on_fight_start(enemy)

export(int) var EndMaxHP = 10
export(int) var EndMaxAttack = 10
export(int) var EndMaxDefence = 10
export(int) var EndMaxPiercing = 0

export(int) var rarity = 0
export(bool) var hover = false

export(int) var factor = 2
export(int) var extent = 10
var time = 0

func _ready():
	$Body.connect("body_entered", self, "on_body_entered")
	
func initialize(portion_id):
	var ratio = clamp(portion_id / float(global.boss_portion_id), 0.0, 1.0)
	MaxHP = int(lerp(MaxHP, EndMaxHP, ratio))
	HP = MaxHP
	attack = int(lerp(attack, EndMaxAttack, ratio))
	defence = int(lerp(defence, EndMaxDefence, ratio))
	piercing = int(lerp(piercing, EndMaxPiercing, ratio))

func _process(delta):
	if hover:
		time += delta * factor
		$Body/Body.position.y = sin(time) * extent

func on_body_entered(other_body):
	if other_body.get_parent() is Player:
		emit_signal("on_fight_start", self)

func play_death_anim():
	get_parent().remove_child(self)

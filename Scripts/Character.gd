class_name Character
extends Node2D

signal on_death(character)

#stats
export(int) var attack = 1
export(int) var defence = 1
export(int) var MaxHP = 1
var HP = 1

func _ready():
	$Body/ProgressBar.set_ratio(1.0)
	HP = MaxHP

func _process(delta):
	pass
			

func receive_damage(enemy_attack : int) -> int:
	var damage = max(enemy_attack - defence, 0)
	HP -= damage
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))
	
	if HP <= 0:
		emit_signal("on_death", self)
	
	return damage

func attack(enemies):
	enemies[0].receive_damage(attack)

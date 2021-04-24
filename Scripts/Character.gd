class_name Character
extends Node2D

signal on_death(character)

var is_dead := false

#stats
export(int) var attack = 1
export(int) var defence = 0
export(int) var MaxHP = 1
var HP = 1
export(float) var time_every_attack = 1.0
var current_time_attack = 1.0


func _ready():
	$Body/ProgressBar.set_ratio(1.0)
	HP = MaxHP

func _process(delta):
	if current_time_attack < time_every_attack:
		current_time_attack += delta
			

func receive_damage(enemy_attack : int) -> int:
	var damage = max(enemy_attack - defence, 0)
	HP -= damage
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))
	
	if HP <= 0:
		is_dead = true
		emit_signal("on_death", self)
	
	print(self.name, " received ", damage, " damages. HP: ", HP)
	return damage

func can_attack():
	return current_time_attack >= time_every_attack

func attack(enemies):
	enemies[0].receive_damage(attack)
	current_time_attack -= time_every_attack 

func is_dead():
	return is_dead

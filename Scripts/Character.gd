class_name Character
extends Node2D

signal on_death(character)

var is_dead := false
var is_paused := false

#stats
export(int) var attack = 1
export(int) var defence = 0
export(int) var MaxHP = 1
var HP = 1.0
export(float) var time_every_attack = 1.0
var current_time_attack = 1.0

#animation
var duration_hit = 0.1
var time_hit = 0.0
var is_playing_hit_anim = false
var damage_anim = load("res://Scenes/DamageUI.tscn")


func _ready():
	$Body/ProgressBar.set_ratio(1.0)
	$Body/ProgressBar/AttackProgressBar.set_ratio(1.0)
	HP = MaxHP

func _process(delta):
	if not is_paused:
		if current_time_attack < time_every_attack:
			current_time_attack += delta
			$Body/ProgressBar/AttackProgressBar.set_ratio(clamp(current_time_attack / time_every_attack, 0.0, 1.0))
			
	if is_playing_hit_anim:
		time_hit += delta
		if time_hit >= duration_hit:
			time_hit = 0
			is_playing_hit_anim = false
			$Body/Body.self_modulate = Color(1.0, 1.0, 1.0)
			

func receive_damage(enemy_attack : int) -> int:
	var damage = max(enemy_attack - defence, 1)
	HP -= damage
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))
	
	#anim
	$Body/Body.self_modulate = Color(1.0, 0.0, 0.0)
	is_playing_hit_anim = true
	var anim = damage_anim.instance()
	$Body.add_child(anim)
	anim.initialize(-damage)
	#end anim
	
	
	if HP <= 0:
		is_dead = true
		emit_signal("on_death", self)
	
	print(self.name, " received ", damage, " damages. HP: ", HP)
	return damage

func can_attack():
	return current_time_attack >= time_every_attack

func attack(enemies):
	current_time_attack -= time_every_attack 
	$Body/ProgressBar/AttackProgressBar.set_ratio(0.0)
	enemies[0].receive_damage(attack)
	$Body/AudioStreamPlayer2D.play()

func is_dead():
	return is_dead

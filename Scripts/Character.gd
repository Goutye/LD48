class_name Character
extends Node2D

signal on_death(character)

var is_dead := false
var is_paused := false

#stats
export(int) var attack = 1
export(int) var defence = 0
export(int) var MaxHP = 1
export(float) var time_every_attack = 1.0
export(float, 0.0, 1.0) var dodge = 0.0
export(float, 0.0, 1.0) var vampirism = 0.0
export(int) var piercing = 0
var HP = 1.0
var attack_speed = 0.0
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
			current_time_attack += delta * (attack_speed + 1.0)
			$Body/ProgressBar/AttackProgressBar.set_ratio(clamp(current_time_attack / time_every_attack, 0.0, 1.0))
			
	if is_playing_hit_anim:
		time_hit += delta
		if time_hit >= duration_hit:
			time_hit = 0
			is_playing_hit_anim = false
			$Body/Body.self_modulate = Color(1.0, 1.0, 1.0)
			

func receive_damage(enemy_attack : int, piercing : int) -> int:
	if randf() < dodge:
		var anim = damage_anim.instance()
		$Body.add_child(anim)
		anim.initialize("dodge")
		if $Body/AudioDodge:
			$Body/AudioDodge.play()
		return 0
	if piercing > 0:
		piercing += 1
	var damage = max(enemy_attack - (max(defence - piercing, 0)), 1)
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
	
	print(self.name, " received ", damage, " damages. HP: ", HP, " Defence: ", defence, " Attack: ", enemy_attack)
	return damage

func can_attack():
	return current_time_attack >= time_every_attack

func update_stats():
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))

func attack(enemies):
	current_time_attack -= time_every_attack 
	$Body/ProgressBar/AttackProgressBar.set_ratio(0.0)
	var real_damage =  enemies[0].receive_damage(attack, piercing)
	if real_damage > 0:
		$Body/AudioStreamPlayer2D.play()
		var heal = vampirism * real_damage
		HP = clamp(HP + heal, 0, MaxHP)
		if int(heal) > 0:
			var anim = damage_anim.instance()
			$Body.add_child(anim)
			anim.initialize(int(heal))
		update_stats()
	else:
		pass

func is_dead():
	return is_dead

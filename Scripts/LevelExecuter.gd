extends Node2D

signal on_level_end(is_success)

export(int) var nb_encounter_min = 5
export(int) var nb_encounter_max = 5
export(float, 0, 1, 0.01) var ratio_enemy = 1
export(float, 0, 1, 0.01) var ratio_treasure = 0

export(Array, PackedScene) var enemies
export(PackedScene) var treasure_scene

var portion_nb_pixels = 64 * 100
var portion_offset_encounter = portion_nb_pixels * 0.1

#fight
var player
var enemy
var is_fighting = false


func _ready():
	pass
	
func initialize(portion_nb, player):
	self.player = player
	
	var nb_encounters = randi() % (nb_encounter_max - nb_encounter_min + 1) + nb_encounter_min
	var start_x = position.x
	
	var area_size = (portion_nb_pixels - portion_offset_encounter) / nb_encounters
	
	for i in range(nb_encounters):
		var encounter_value = randf()
		
		if encounter_value < ratio_enemy:
			var enemy = enemies[randi() % enemies.size()].instance()
			add_child(enemy)
			enemy.position.x = randf() * area_size + start_x + portion_offset_encounter * 0.5 + i * area_size
			enemy.position.y = player.get_feet_position().y
			enemy.connect("on_fight_start", self, "on_fight_start")
		elif encounter_value < ratio_enemy + ratio_treasure:
			var treasure = treasure_scene.instance()
			add_child(treasure)
			treasure.position.x = randf() * area_size + start_x + portion_offset_encounter * 0.5 + i * area_size
			treasure.position.y = player.get_feet_position().y
			treasure.initialize(portion_nb)

func _process(delta):
	if is_fighting:
		fight()

func on_fight_start(enemy):
	self.enemy = enemy
	player.start_fight()
	is_fighting = true

func fight():
	if player.can_attack():
		player.attack([enemy])
	
	if not enemy.is_dead():
		if enemy.can_attack():
			enemy.attack([player])
	else:
		remove_child(enemy)
		is_fighting = false
		player.end_fight()
		
	if player.is_dead():
		is_fighting = false
		emit_signal("on_level_end", false)

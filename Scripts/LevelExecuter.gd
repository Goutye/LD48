extends Node2D

signal on_level_end(is_success)

export(int) var nb_encounter_min = 5
export(int) var nb_encounter_max = 5
export(float, 0, 1, 0.01) var ratio_enemy = 1
export(float, 0, 1, 0.01) var ratio_treasure = 0

export(Array, PackedScene) var enemies
var boss_scene = load("res://Scenes/Boss.tscn")
export(PackedScene) var treasure_scene
var tilesets = [load("res://Scenes/TilesetForest.tres"), load("res://Scenes/TilesetLava.tres"), load("res://Scenes/TilesetStone.tres"), load("res://Scenes/TilesetIce.tres")]
var tileset

var portion_nb_pixels = 64 * 100
var portion_offset_encounter = portion_nb_pixels * 0.1

#fight
var player
var enemy
var is_fighting = false

#stats
var portion_id


func _ready():
	pass
	
func initialize(portion_nb, player):
	self.player = player
	portion_id = portion_nb
	
	if (portion_id + 1) % global.boss_portion_id != 0 :
		tileset = tilesets[randi() % tilesets.size()]
		$Background.tile_set = tileset
		$Playerground.tile_set = tileset
		$Foreground.tile_set = tileset
	
	var nb_encounters = randi() % (nb_encounter_max - nb_encounter_min + 1) + nb_encounter_min
	var start_x = position.x
	
	var area_size = (portion_nb_pixels - portion_offset_encounter) / nb_encounters
	
	print(start_x, " ", player.position)
	for i in range(nb_encounters):
		if (portion_id + 1) % global.boss_portion_id == 0 and i == nb_encounters - 1:
			var boss = boss_scene.instance()
			add_child(boss)
			boss.position.x = area_size * 0.5 + portion_offset_encounter * 0.5 + i * area_size
			boss.position.y = player.get_feet_position().y
			boss.connect("on_fight_start", self, "on_fight_start")
			continue
		
		var encounter_value = randf()
		
		if encounter_value < ratio_enemy:
			var enemy = enemies[randi() % enemies.size()].instance()
			add_child(enemy)
			enemy.position.x = randf() * area_size + portion_offset_encounter * 0.5 + i * area_size
			enemy.position.y = player.get_feet_position().y
			enemy.connect("on_fight_start", self, "on_fight_start")
		elif encounter_value < ratio_enemy + ratio_treasure:
			var treasure = treasure_scene.instance()
			add_child(treasure)
			treasure.position.x = randf() * area_size + portion_offset_encounter * 0.5 + i * area_size
			treasure.position.y = player.get_feet_position().y
			treasure.initialize(portion_nb)
		else:
			print("bad value for encounter")

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
		enemy.play_death_anim()
		is_fighting = false
		player.end_fight()
		player.display_loots(portion_id, enemy.rarity, false)
		
	if player.is_dead():
		is_fighting = false
		player.end_fight()
		player.start_ui()
		emit_signal("on_level_end", true)

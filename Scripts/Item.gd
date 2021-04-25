class_name Item
enum ItemType {HELMET, ARMOR, WEAPON, POTION, ABILITY, PROFESSION}

var helmet_names = ["Helmet"]
var armor_names = ["Armor"]
var weapon_names = ["Weapon"]
var potion_names = ["Heal Potion"]

var helmet_vars = ["defence", "dodge", "HP", "attack_speed"]
var armor_vars = ["defence", "dodge", "HP", "vampirism"]
var weapon_vars = ["attack_speed", "vampirism", "piercing"]

#stats
var name = "Basic"
var type = ItemType.HELMET
var attack = 0
var defence = 0
var HP = 0
var heal = 0.0
var attack_speed = 0.0
var piercing = 0
var dodge = 0.0
var vampirism = 0.0

func initialize(portion_id, rarity, is_treasure):
	if is_treasure:
		initialize_treasure_loots(portion_id, rarity)
	else:
		initialize_enemy_loots(portion_id, rarity)
	
func initialize_enemy_loots(portion_id, rarity):
	var rand_value = randi() % 3
	var nb_stats = clamp(randi() % (rarity + 1 + (portion_id / 3)) + 1, 1, 4)
	
	if rand_value == 0:
		name = helmet_names[randi() % helmet_names.size()]
		type = ItemType.HELMET
		var vars = helmet_vars.duplicate()
		for i in range(nb_stats):
			generate_one_stat(vars, portion_id, rarity)
	elif rand_value == 1:
		name = armor_names[randi() % armor_names.size()]
		type = ItemType.ARMOR
		var vars = armor_vars.duplicate()
		for i in range(nb_stats):
			generate_one_stat(vars, portion_id, rarity)
	else:
		name = weapon_names[randi() % weapon_names.size()]
		type = ItemType.WEAPON
		var vars = weapon_vars.duplicate()
		generate_one_stat(weapon_vars, portion_id, rarity, "attack")
		for i in range(nb_stats - 1):
			generate_one_stat(vars, portion_id, rarity)

func initialize_treasure_loots(portion_id, rarity):
	var rand_value = randi() % 1
	
	if rand_value == 0:
		name = potion_names[randi() % potion_names.size()]
		type = ItemType.POTION
		heal = rand_range(0.1, 0.3)
	elif rand_value == 1:
		type = ItemType.ABILITY
		HP = (randi() % 5 - 1) + portion_id + 3
	else:
		type = ItemType.PROFESSION
		attack = (randi() % 3 - 1) + portion_id + 2

func generate_one_stat(vars, portion_id, rarity, stat = ""):
	if stat == "":
		stat = vars[randi() % vars.size()]
		vars.remove(stat)
	var variability = 0.1 * (rarity + 1)
	
	if stat == "attack":
		var maxAtk = 75
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		attack = int(rand_range(minValue, maxValue))
	elif stat == "defence":
		var maxAtk = 40
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		defence = int(rand_range(minValue, maxValue))
		pass
	elif stat == "piercing":
		var maxAtk = 25
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		piercing = int(rand_range(minValue, maxValue))
	elif stat == "attack_speed":
		var maxAtk = 1.0
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		attack_speed = rand_range(minValue, maxValue)
	elif stat == "vampirism":
		var maxAtk = 0.3
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		vampirism = rand_range(minValue, maxValue)
		pass
	elif stat == "dodge":
		var maxAtk = 0.3
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		dodge = rand_range(minValue, maxValue)
	elif stat == "HP":
		var maxAtk = 500
		var ratio = max(portion_id / float(global.boss_portion_id - 1), 0.05)
		var middleValue = ratio * maxAtk
		var minValue = middleValue * (1 - variability)
		var maxValue = middleValue * (1 + variability)
		HP = int(rand_range(minValue, maxValue))

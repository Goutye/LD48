class_name Item
enum ItemType {HELMET, ARMOR, WEAPON, POTION, ABILITY, PROFESSION}

var helmet_names = ["Helmet"]
var armor_names = ["Armor"]
var weapon_names = ["Weapon"]
var potion_names = ["Heal Potion"]

#stats
var name = "Basic"
var type = ItemType.HELMET
var attack = 0
var defence = 0
var HP = 0
var heal = 0

func initialize(portion_id, rarity, is_treasure):
	if is_treasure:
		initialize_treasure_loots(portion_id, rarity)
	else:
		initialize_enemy_loots(portion_id, rarity)
	
func initialize_enemy_loots(portion_id, rarity):
	var rand_value = randi() % 3
	
	if rand_value == 0:
		name = helmet_names[randi() % helmet_names.size()]
		type = ItemType.HELMET
		defence = (randi() % 3 - 1) + portion_id + 2
	elif rand_value == 1:
		name = armor_names[randi() % armor_names.size()]
		type = ItemType.ARMOR
		HP = (randi() % 5 - 1) + portion_id + 3
	else:
		name = weapon_names[randi() % weapon_names.size()]
		type = ItemType.WEAPON
		attack = (randi() % 3 - 1) + portion_id + 2

func initialize_treasure_loots(portion_id, rarity):
	var rand_value = randi() % 1
	
	if rand_value == 0:
		name = potion_names[randi() % potion_names.size()]
		type = ItemType.POTION
		heal = (randi() % 3 - 1) + portion_id + 2
	elif rand_value == 1:
		type = ItemType.ABILITY
		HP = (randi() % 5 - 1) + portion_id + 3
	else:
		type = ItemType.PROFESSION
		attack = (randi() % 3 - 1) + portion_id + 2

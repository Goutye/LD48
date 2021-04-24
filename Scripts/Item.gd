class_name Item
enum ItemType {HELMET, ARMOR, WEAPON}

#stats
var name = "Basic"
var type = ItemType.HELMET
var attack = 0
var defence = 0
var HP = 0

func initialize(portion_id, rarity):
	var rand_value = randi() % 3
	
	if rand_value == 0:
		type = ItemType.HELMET
		defence = (randi() % 3 - 1) + portion_id + 2
	elif rand_value == 1:
		type = ItemType.ARMOR
		HP = (randi() % 5 - 1) + portion_id + 3
	else:
		type = ItemType.WEAPON
		attack = (randi() % 3 - 1) + portion_id + 2

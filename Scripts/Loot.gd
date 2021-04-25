extends TextureRect

var HelmetTexture = load("res://Assets/Images/helmet.png")
var ArmorTexture = load("res://Assets/Images/armor.png")
var WeaponTexture = load("res://Assets/Images/weapon.png")
var PotionTexture = load("res://Assets/Images/potion.png")

func _ready():
	pass
	
func initialize(type):
	if type == Item.ItemType.HELMET:
		texture = HelmetTexture
	elif type == Item.ItemType.ARMOR:
		texture = ArmorTexture
	elif type == Item.ItemType.WEAPON:
		texture = WeaponTexture
	elif type == Item.ItemType.POTION:
		texture = PotionTexture

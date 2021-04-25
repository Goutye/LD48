class_name Player
extends Character

signal on_level_portion_almost_finished

#move
var velocity: Vector2 = Vector2(0, 0) #pixels per seconds
var run_speed = 50
var max_speed = 300
var gravity = 1200
var jump_impulse = Vector2(0, -600)
var body

#camera/level
var camera_nb_pixels_displayed = 20 * 64
var nb_pixels_per_level_portion = 100 * 64
var should_check_portion = true

#fight
var is_fighting := false

#wearable
var helmet
var armor
var weapon

#stats
var BaseMaxHP = 10
var BaseAttack = 1
var BaseDefence = 1
var BaseRegen = 0


func _ready():
	body = $Body
	$Body/Camera2D/Inventory.initialize($Body/Camera2D, self)
	$Body/Camera2D/LootUI.visible = false
	reset()
	
func reset():
	#stats
	helmet = Item.new()
	helmet.type = Item.ItemType.HELMET
	helmet.defence = 1
	armor = Item.new()
	armor.type = Item.ItemType.ARMOR
	armor.HP = 1
	weapon = Item.new()
	weapon.type = Item.ItemType.WEAPON
	weapon.attack = 1
	HP = MaxHP
	
	update_stats()
	
	is_paused = false
	should_check_portion = true
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))
	$Body.position.x = 0


func _process(delta):
	$Body/Camera2D/Inventory/BossBar.set_ratio($Body.position.x / (64 * 1000))
	
	if not is_paused and not is_fighting:
		#check position
		if should_check_portion:
			check_portion()
		else:
			var current_pixel_in_level = int(body.position.x) % nb_pixels_per_level_portion
			if current_pixel_in_level >= 0 and current_pixel_in_level < camera_nb_pixels_displayed:
				should_check_portion = true	

func _physics_process(delta):
	if not is_paused and not is_fighting:
		velocity.x += run_speed
		velocity.x = clamp(velocity.x, 0, max_speed)
		
		velocity.y += gravity * delta
		velocity = $Body.move_and_slide(velocity, Vector2(0, -1))
	
func check_portion():
	var current_pixel_in_level = int(body.position.x) % nb_pixels_per_level_portion
	if current_pixel_in_level >= nb_pixels_per_level_portion - camera_nb_pixels_displayed:
		should_check_portion = false
		emit_signal("on_level_portion_almost_finished")

func get_feet_position():
	return $Body.global_position - $Body.position

func update_stats():
	var prevMaxHP = MaxHP
	MaxHP = BaseMaxHP + helmet.HP + armor.HP + weapon.HP
	defence = BaseDefence + helmet.defence + armor.defence + weapon.defence
	attack = BaseAttack + helmet.attack + armor.attack + weapon.attack
	
	var diffMaxHP = MaxHP - prevMaxHP
	if diffMaxHP > 0:
		HP += diffMaxHP
		var anim = damage_anim.instance()
		$Body.add_child(anim)
		anim.initialize(diffMaxHP)
		
	$Body/Camera2D/Inventory.update_stats_ui()
	$Body/ProgressBar.set_ratio(HP / float(MaxHP))

func display_loots(portion_id, rarity, is_treasure):
	$Body/Camera2D/LootUI.initialize(portion_id, rarity, is_treasure, self)

func equip(item):
	if item.type == Item.ItemType.HELMET:
		$Body/AudioEquip.play()
		helmet = item
	elif item.type == Item.ItemType.ARMOR:
		$Body/AudioEquip.play()
		armor = item
	elif item.type == Item.ItemType.WEAPON:
		$Body/AudioEquip.play()
		weapon = item
	elif item.type == Item.ItemType.POTION:
		$Body/AudioPotion.play()
		HP = clamp(HP + item.heal, 0, MaxHP)
		var anim = damage_anim.instance()
		$Body.add_child(anim)
		anim.initialize(item.heal)
	
	update_stats()

func toggle_inventory_ui(value):
	$Body/Camera2D/Inventory.visible = value
	
func toggle_titlescreen_ui(value):
	$Body/Camera2D/TitleScreenUI.visible = value

func start_fight():
	is_fighting = true
	
func end_fight():
	is_fighting = false
	
func start_ui():
	is_paused = true
	
func end_ui():
	is_paused = false

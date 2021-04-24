class_name Player
extends Character

signal on_level_portion_almost_finished

#move
var speed: Vector2 = Vector2(512, 0) #pixels per seconds
var body

#camera/level
var camera_nb_pixels_displayed = 20 * 64
var nb_pixels_per_level_portion = 100 * 64
var should_check_portion = true

#fight
var is_paused := false

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
	reset()
	$Body/Camera2D/Inventory.initialize($Body/Camera2D, self)
	
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
	if not is_paused:
		var collision = body.move_and_collide(speed * delta)
		
		#check position
		if should_check_portion:
			check_portion()
		else:
			var current_pixel_in_level = int(body.position.x) % nb_pixels_per_level_portion
			if current_pixel_in_level >= 0 and current_pixel_in_level < camera_nb_pixels_displayed:
				should_check_portion = true	
	
	
func check_portion():
	var current_pixel_in_level = int(body.position.x) % nb_pixels_per_level_portion
	if current_pixel_in_level >= nb_pixels_per_level_portion - camera_nb_pixels_displayed:
		should_check_portion = false
		emit_signal("on_level_portion_almost_finished")

func get_feet_position():
	return $Body.global_position - $Body.position

func update_stats():
	MaxHP = BaseMaxHP + helmet.HP + armor.HP + weapon.HP
	defence = BaseDefence + helmet.defence + armor.defence + weapon.defence
	attack = BaseAttack + helmet.attack + armor.attack + weapon.attack

func start_fight():
	is_paused = true
	
func end_fight():
	is_paused = false
	
func start_ui():
	is_paused = true
	
func end_ui():
	is_paused = false

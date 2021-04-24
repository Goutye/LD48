extends Character

signal on_level_portion_almost_finished

#move
var speed: Vector2 = Vector2(512, 0) #pixels per seconds
var body

#camera/level
var camera_nb_pixels_displayed = 20 * 64
var nb_pixels_per_level_portion = 100 * 64
var should_check_portion = true


func _ready():
	body = $Body
	
	#stats
	attack = 1
	defence = 1
	MaxHP = 10
	HP = MaxHP
	
	receive_damage(6)

func _process(delta):
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

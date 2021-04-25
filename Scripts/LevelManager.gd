extends Node2D

signal level_start(level_nb)

var levels = [['Title'], ['Forest1', 'Forest2', 'Forest3', 'Forest4']]
var level_offset = Vector2(64*100, 0)
var current_level := 0
var current_level_scene = null
var was_success = false
var _level_loading_in_progress = false
var level_portion_id := 0

func _ready():
	randomize()
	load_current_level()
	
	$Transition.connect("anim_end", self, "on_anim_end")
	$Transition.connect("start_level_anim_end", self, "on_start_level_anim_end")
	$Transition.connect("end_level_anim_end", self, "on_anim_end")
	self.connect("level_start", global, "on_level_start")
	$Characters/Player.connect("on_level_portion_almost_finished", self, "on_level_portion_almost_finished")

func _process(delta):
	if Input.is_action_just_pressed("level_restart"):
		if not _level_loading_in_progress:
			load_current_level()
	elif Input.is_action_just_pressed("game_full_restart"):
		if not _level_loading_in_progress:
			current_level = 0
			load_current_level()
	if not _level_loading_in_progress:
		if Input.is_action_just_pressed("prev_level"):
			on_level_end(false)
			current_level = (current_level - 1 + levels.size()) % levels.size()
		if Input.is_action_just_pressed("next_level"):
			on_level_end(false)
			current_level = (current_level + 1) % levels.size()
		
	if current_level_scene != null:
		var text
		#$UI/Label.text = 'Level ' + levels[current_level]

func load_current_level():
	#clean up
	for child in $Level.get_children():
		$Level.remove_child(child)
	
	$Characters/Player.reset()
	
	if current_level != 0:
		$Characters/Player.toggle_inventory_ui(true)
		$Characters/Player.toggle_titlescreen_ui(false)
		var portion_nb = randi() % levels[current_level].size()
		var prev_level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()
		$Level.add_child(prev_level_scene)
		prev_level_scene.position = -level_offset
	else:
		$Characters/Player.toggle_inventory_ui(false)
		$Characters/Player.toggle_titlescreen_ui(true)
		$Characters/Player/Body/Camera2D/TitleScreenUI/Control/Button.disabled = false
		$Characters/Player/Body/Camera2D/TitleScreenUI/Control/Button.connect("pressed", self, "start_button_pressed")
	
	var portion_nb = randi() % levels[current_level].size()
	current_level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()
	current_level_scene.initialize(0, $Characters/Player)
	
	#load level
	$Level.add_child(current_level_scene)
	current_level_scene.connect("on_level_end", self, "on_level_end")
	
	if was_success:
		$Transition.play_start_level_transition()
	else :
		$Transition.play_start_level_transition()
		
	
	emit_signal("level_start", current_level)

func on_level_end(is_success):
	_level_loading_in_progress = true
	was_success = is_success
	
	if is_success:
		current_level = (current_level + 1) % levels.size()
	else:
		level_portion_id = 0
	$Transition.play_end_level_transition()
		
func on_level_portion_almost_finished():
	level_portion_id += 1
	$Level.remove_child($Level.get_child(0))
	
	var level_scene
	if (level_portion_id + 1) % global.boss_portion_id == 0:
		level_scene = load('res://Levels/LevelBoss.tscn').instance()
	else:
		var portion_nb = randi() % levels[current_level].size()
		level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()
	$Level.add_child(level_scene)
	level_scene.position = $Level.get_child(0).position + level_offset
	level_scene.initialize(level_portion_id, $Characters/Player)
	level_scene.connect("on_level_end", self, "on_level_end")

func on_anim_end():
	load_current_level()

func on_start_level_anim_end():
	_level_loading_in_progress = false

func get_time_ratio_before_rope_breaks():
	return current_level_scene.get_time_ratio_before_rope_breaks()

func start_button_pressed():
	$Characters/Player/Body/Camera2D/TitleScreenUI/Control/Button/AudioStreamPlayer2D.play()
	$Characters/Player/Body/Camera2D/TitleScreenUI/Control/Button.disabled = true
	on_level_end(false)
	current_level = (current_level + 1) % levels.size()

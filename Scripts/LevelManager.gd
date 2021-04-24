extends Node2D

signal level_start(level_nb)

var levels = [['Forest1', 'Forest2', 'Forest3', 'Forest4']]
var level_offset = Vector2(64*100, 0)
var current_level := 0
var current_level_scene = null
var was_success = false
var _level_loading_in_progress = false

onready var global = get_node("/root/global")

func _ready():
	load_current_level()
	
	$Transition.connect("anim_end", self, "on_anim_end")
	$Transition.connect("start_level_anim_end", self, "on_start_level_anim_end")
	$Transition.connect("end_level_anim_end", self, "on_anim_end")
	self.connect("level_start", global, "on_level_start")
	$Characters/Character.connect("on_level_portion_almost_finished", self, "on_level_portion_almost_finished")

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
	if current_level_scene != null:
		$Level.remove_child(current_level_scene)
	
	
	var portion_nb = randi() % levels[current_level].size()
	var prev_level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()
	$Level.add_child(prev_level_scene)
	prev_level_scene.position = -level_offset
	
	portion_nb = randi() % levels[current_level].size()
	current_level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()

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
		$Transition.play_end_level_transition()
	else:
		$Transition.play_end_level_transition()
		
func on_level_portion_almost_finished():
	$Level.remove_child($Level.get_child(0))
	var portion_nb = randi() % levels[current_level].size()
	var level_scene = load('res://Levels/Level' + levels[current_level][portion_nb] + '.tscn').instance()
	$Level.add_child(level_scene)
	level_scene.position = $Level.get_child(0).position + level_offset

func on_anim_end():
	load_current_level()

func on_start_level_anim_end():
	_level_loading_in_progress = false

func get_time_ratio_before_rope_breaks():
	return current_level_scene.get_time_ratio_before_rope_breaks()

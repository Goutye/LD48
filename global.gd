extends Node

var camera
var current_scene
var level_loader

#stats
var nb_restart = 0
var time = 0
var nb_skip = 0

var boss_portion_id = 10

#onready var block_class = load("res://Script/Base/Block.gd")
#onready var user_data_tracker_class = load("res://Script/UserDataTracker.gd")
#var BLOCK_TYPE
#var user_data_tracker

#functions
func _ready():
	#BLOCK_TYPE = block_class.BLOCK_TYPE
	#user_data_tracker = user_data_tracker_class.new()

	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	level_loader = current_scene

func _process(delta):
	time += delta
	
	if delta > 1.0/50.0:
		print(delta, " -> ", 1.0/delta, " (", 1.0/60.0, ")")

func _deferred_goto_scene(path):

	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()

	# Load new scene
	var s = ResourceLoader.load(path)

	# Instance the new scene
	current_scene = s.instance()

	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)

	# optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( current_scene )
	
	#post
	#post_load_scene()
	
func reset_stats():
	time = 0

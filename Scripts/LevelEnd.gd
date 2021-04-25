extends Node2D

signal on_level_end(is_success)
var player
var offset = 64*7

var boss_move = 0
var factor = 2
var boss_position_y

func initialize(portion_id, player):
	self.player = player
	player.is_fighting = false
	player.is_paused = false
	boss_position_y = $Boss.position.y
	
func _process(delta):
	boss_move += delta * factor
	$Boss.position.x = player.get_node("Body").position.x + offset
	$Boss.rotation = boss_move
	
func _on_Area2D_body_entered(body):
	if body.get_parent() is Player:
		body.position.x -= 64*20*4

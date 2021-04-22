extends Node2D

signal end_level_anim_end
signal start_level_anim_end

export var scale_begin = 25.0
export var duration_end = 1.5
export var duration_start = 1.5

var _offset

func _ready():
	_offset = $Animation.position.x
	
func play_end_level_transition():
	$Animation.position.x = -_offset
	$Animation.modulate.a = 1
	$Animation.scale = Vector2(0.01, 0.01)
	flux.to($Animation, duration_end, {scale_x = scale_begin}, "absolute").ease("back","out")
	flux.to($Animation, duration_end, {scale_y = scale_begin}, "absolute").ease("back","out").oncomplete.append(funcref(self, "on_end_anim_end"))

func play_start_level_transition():
	flux.to($Animation, duration_start, {x2D = 10}, "relative").ease("quad", "out")
	flux.to($Animation, duration_start, {modulate_a = 0}, "absolute").ease("quad", "in").oncomplete.append(funcref(self, "on_start_anim_end"))

func on_start_anim_end():
	emit_signal("start_level_anim_end")

func on_end_anim_end():
	emit_signal("end_level_anim_end")

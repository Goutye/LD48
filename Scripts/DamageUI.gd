extends Node2D



var direction = Vector2(0, -1)
var angle = 15
var duration_modulate_in = 0.2
var duration_modulate_out = 1.8

func _ready():
	pass
	
func initialize(damage):
	if damage is int or damage is float:
		if damage < 0:
			$Label.modulate = Color(1.0, 0.0, 0.0, 0.0)
		else:
			$Label.modulate = Color(0.0, 1.0, 0.0, 0.0)
		damage = str(abs(damage))
	$Label.text = damage
	
	flux.to(self, duration_modulate_in + duration_modulate_out, {y2D = -20}, "absolute").ease("quad","out")
	flux.to($Label, duration_modulate_in, {modulate_a = 1.0}, "absolute").ease("quad","out").oncomplete.append(funcref(self, "on_anim_first_end"))
	
func on_anim_first_end():
	flux.to($Label, duration_modulate_in, {modulate_a = 0.0}, "absolute").ease("quad","in").oncomplete.append(funcref(self, "on_anim_second_end"))

func on_anim_second_end():
	get_parent().remove_child(self)

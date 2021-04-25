extends Enemy

func play_death_anim():
	$Body/AudioDeath.connect("finished", self, "on_sound_end")
	$Body/AudioDeath.play()
	
func on_sound_end():
	get_parent().remove_child(self)

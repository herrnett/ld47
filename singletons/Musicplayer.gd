extends AudioStreamPlayer

onready var tween = get_node("Tween")

func fade_out():
	# tween music volume down to 0
	tween.interpolate_property(self, "volume_db", 6, -80, 5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	self.playing = false

func fade_in():
	self.playing = true
	tween.interpolate_property(self, "volume_db", -80, 6, 4, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

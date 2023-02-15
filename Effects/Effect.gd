extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0 #Starts on frame 0 of the animation
	play("Animate") #Plays animation of whatever effect we want

#When the animation is done, the effect will be destroyed
func _on_animation_finished():
	queue_free()

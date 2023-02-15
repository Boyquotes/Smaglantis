extends CanvasModulate

func _process(_delta):
	var time = OS.get_time() #Gets system time
	var TimeInSeconds = time.hour * 3600 + time.minute * 60 + time.second
	var currentFrame = range_lerp(TimeInSeconds,0,86400,0,24)
	$AnimationPlayer.play("Day_Night_Cycle")
	$AnimationPlayer.seek(currentFrame)

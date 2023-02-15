extends Area2D

var player = null 

func can_see_player():
	return player != null #Returns true or false if player is in or not in detection zone

func _on_PlayerDetectionZone_body_entered(body):
	player = body #Player is gonna be body when entering the zone
	
func _on_PlayerDetectionZone_body_exited(_body):
	player = null #Player is null when outside of detection zone



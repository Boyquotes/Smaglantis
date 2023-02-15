extends Node

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

func shake(intensity, duration):
	#Set the shake parameters
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		
func _process(delta):
	#Gets the camera
	var camera = get_tree().current_scene.get_node("Camera2D")
	
	#Stops shaking if the camera shake duration timer is at 0
	if camera_shake_duration <= 0:
		#Resets the camera when the shake is over
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
		
	#Subtracts extra time from the camera shake duration until it ends
	camera_shake_duration = camera_shake_duration - delta
		
	#Shakes the camera
	var offset = Vector2.ZERO
	
	offset = Vector2(randf(), randf()) * camera_shake_intensity
	
	camera.offset = offset

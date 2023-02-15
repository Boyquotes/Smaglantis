extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position #Gets position of the wander controller
onready var target_position = global_position #Enemies wander area

onready var timer = $Timer

#Some enemies will stay idle or move
func _ready():
	update_target_position()

func update_target_position(): 
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	#Update target positon
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left
	
func start_wander_timer(duration):
	timer.start(duration)	
	
#Every second it will pick a new target position to wander too
func _on_Timer_timeout():
	update_target_position()

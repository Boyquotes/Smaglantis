extends Area2D

func is_colliding():
	var areas = get_overlapping_areas() #Checks if the collision boxes of enemies are colliding 
	return areas.size() > 0 #Returns true if it detects 2 enemies colliding
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] #get first index of the area array
		push_vector = area.global_position.direction_to(global_position) #global position we are colliding it
		push_vector = push_vector.normalized() #normalized push vector
	return push_vector #returns 0 if we don't collide with anything

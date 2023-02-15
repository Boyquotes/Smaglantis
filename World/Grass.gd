extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn") #A path to preload the grass breaking effect

func create_grass_effect():
	#Instance of GrassEffect
	var grassEffect = GrassEffect.instance() #A packed scene: Not a node, an actual scene
	#Get access to the root world node
	get_parent().add_child(grassEffect) 
	grassEffect.global_position = global_position #Gets global position of all the grass in the world

#When the hitbox overlays with the hurt box, the grass will be destroyed	
func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free() #If node is a physically destroyed from the game, queue_free will remove the memory of the node

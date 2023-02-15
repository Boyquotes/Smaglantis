extends Area2D

func _ready():
	pass # Replace with function body.

#Dicitionary
var items_in_range = {}

func _on_PickupZone_body_entered(body):
	#Player picks up items in range
	items_in_range[body] = body

func _on_PickupZone_body_exited(body):
	#erases item from dictionary when picked up
	if items_in_range.has(body):
		items_in_range.erase(body)

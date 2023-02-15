extends Node

export(int) var max_health = 1
export(int) var max_stamina = 1
onready var health = max_health setget set_health #Makes this a getter and setter
onready var stamina = max_stamina setget set_stamina

signal no_health #Creates a new signal

signal no_stamina

func set_health(value):
	health = value
	#If health is less than 0, the signal is emited to tell the game
	if health <= 0:
		emit_signal("no_health")
		
func set_stamina(value):
	stamina = value
	if stamina <=0:
		emit_signal("no_stamina")

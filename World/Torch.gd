extends Node2D


onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	animationPlayer.play("Lighting")
	

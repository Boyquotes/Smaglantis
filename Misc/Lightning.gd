extends Node2D

onready var sprite_texture = [ preload("res://Effects/lightning1.png"),
					preload("res://Effects/lightning2.png"),
					preload("res://Effects/lightning3.png")]


func _ready():
	$Timer.wait_time = rand_range(3, 15)
	$Timer.start()
	
func lightning():
	$Sprite.texture = sprite_texture[randi() % 3]
	position.x = rand_range(0, 320)
	$AnimationPlayer.play("Lightning")
	$Timer.wait_time = rand_range(3, 15)
	$Timer.start()
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	pass

func _on_Timer_timeout():
	lightning()

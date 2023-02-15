extends TextureRect

func _ready():
	if randi() % 2 == 0:
		$TexureRect.texture = load("res://Items/Weapons/Swords/Iron Sword Item.png")
	else:
		$TexureRect.texture = load("res://Items/Weapons/Swords/Steel Sword Item.png")
	


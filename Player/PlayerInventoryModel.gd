extends KinematicBody2D

var data = null
const composite_sprites = preload("res://CompositeSprites.gd")

#Gets access to all the layers that make up the player
onready var bodySprite = get_parent().get_node("Player/Body")
onready var hairSprite = get_parent().get_node("Player/Hair")
onready var eyesSprite = get_parent().get_node("Player/Eyes")
onready var pantsSprite = get_parent().get_node("Player/Pants")
onready var shirtSprite = get_parent().get_node("Player/Shirt")
onready var shoesSprite = get_parent().get_node("Player/Shoes")
onready var accessoriesSprite = get_parent().get_node("Player/Accessories")
onready var facialHairSprite = get_parent().get_node("Player/FacialHair")

onready var blinkAnimationPlayer = $BlinkAnimationPlayer

var skin_color: Color
var hair_color: Color
var facial_hair_color: Color

var shirtSlot
var pantsSlot
var shoesSlot

func _ready():
	data = DataManager.load_game()
	#Loads character customization choices
	hairSprite.texture = composite_sprites.hair_spritesheet[int(data["Hair"])]
	eyesSprite.texture = composite_sprites.eyes_spritesheet[int(data["Eyes"])]
	pantsSprite.texture = composite_sprites.pants_spritesheet[int(data["Pants"])]
	shirtSprite.texture = composite_sprites.shirt_spritesheet[int(data["Shirt"])]
	shoesSprite.texture = composite_sprites.shoes_spritesheet[int(data["Shoes"])]
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[int(data["Accessories"])]
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[int(data["FacialHair"])]
	
	#Hides player shadow
	get_parent().get_node("Player/Shadow").hide()
	
	#Loads skin color
	skin_color = data["SkinColor"]
	bodySprite.modulate = skin_color
	
	#Loads hair color
	hair_color = data["HairColor"]
	hairSprite.modulate = hair_color
	
	#Loads facial hair color
	facial_hair_color = data["FacialHairColor"]
	facialHairSprite.modulate = facial_hair_color
	
	#Loads shirt,pants, and shoes slot
	shirtSlot = data["PlayerShirtSlot"]
	pantsSlot = data["PlayerPantsSlot"]
	shoesSlot = data["PlayerShoesSlot"]
	
	#Shirt options that are loaded
	if shirtSlot == "Blue Jacket":
		PlayerInventory.equips[0] = ["Blue Jacket", 1]
	if shirtSlot == "Black Shirt":
		PlayerInventory.equips[0] = ["Black Shirt", 1]
	if shirtSlot == "Red Shirt":
		PlayerInventory.equips[0] = ["Red Shirt", 1]
		
	#Pants options that are loaded
	if pantsSlot == "Black Jeans":
		PlayerInventory.equips[1] = ["Black Jeans", 1]
	if pantsSlot == "Blue Jeans":
		PlayerInventory.equips[1] = ["Blue Jeans", 1]
		
	#Shoe options that are loaded
	if shoesSlot == "Blue Shoes":
		PlayerInventory.equips[2] = ["Blue Shoes", 1]
	if shoesSlot == "Black Shoes":
		PlayerInventory.equips[2] = ["Black Shoes", 1]
	if shoesSlot == "Red Shoes":
		PlayerInventory.equips[2] = ["Red Shoes", 1]
	
func _physics_process(delta):
	if Globalvars.playerBlink == true:
		bodySprite.modulate = Color(255,255,255,255)
		hairSprite.modulate = Color('ffffff')
		facialHairSprite.modulate = Color('ffffff')
	else:
		bodySprite.modulate = skin_color
		hairSprite.modulate = hair_color
		facialHairSprite.modulate = facial_hair_color

	#If player takes off shirt
	if Globalvars.is_wearing_shirt == false:
		shirtSprite.texture = composite_sprites.shirt_spritesheet[0]
	
	#If player puts on one of the shirts below
	if Globalvars.is_wearing_shirt == true:
		if Globalvars.is_blue_jacket_equipped == true:
			shirtSprite.texture = composite_sprites.shirt_spritesheet[1]
		if Globalvars.is_black_shirt_equipped == true:
			shirtSprite.texture = composite_sprites.shirt_spritesheet[2]
		if Globalvars.is_red_shirt_equipped == true:
			shirtSprite.texture = composite_sprites.shirt_spritesheet[3]
	
	#If player takes off pants
	if Globalvars.is_wearing_pants == false:
		pantsSprite.texture = composite_sprites.pants_spritesheet[0]
		
	#If player puts on one of the pants below
	if Globalvars.is_wearing_pants == true:
		if Globalvars.is_black_jeans_equipped == true:
			pantsSprite.texture = composite_sprites.pants_spritesheet[1]
		if Globalvars.is_blue_jeans_equipped == true:
			pantsSprite.texture = composite_sprites.pants_spritesheet[2]
			
	#If player takes off shoes
	if Globalvars.is_wearing_shoes == false:
		shoesSprite.texture = composite_sprites.shoes_spritesheet[0]
		
	#If player puts on shoes below
	if Globalvars.is_wearing_shoes == true:
		if Globalvars.is_blue_shoes_equipped == true:
			shoesSprite.texture = composite_sprites.shoes_spritesheet[1]
		if Globalvars.is_black_shoes_equipped == true:
			shoesSprite.texture = composite_sprites.shoes_spritesheet[2]
		if Globalvars.is_red_shoes_equipped == true:
			shoesSprite.texture = composite_sprites.shoes_spritesheet[3]
			

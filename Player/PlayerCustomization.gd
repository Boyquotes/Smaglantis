extends KinematicBody2D

#Gets access to all the layers that make up the player
onready var bodySprite = get_parent().get_node("Player/Body")
onready var hairSprite = get_parent().get_node("Player/Hair")
onready var eyesSprite = get_parent().get_node("Player/Eyes")
onready var pantsSprite = get_parent().get_node("Player/Pants")
onready var shirtSprite = get_parent().get_node("Player/Shirt")
onready var shoesSprite = get_parent().get_node("Player/Shoes")
onready var accessoriesSprite = get_parent().get_node("Player/Accessories")
onready var facialHairSprite = get_parent().get_node("Player/FacialHair")

onready var text = $EnterName
onready var nameText = $NameText

#Preloads all the sprites for different parts of the player
const composite_sprites = preload("res://CompositeSprites.gd")

var playerName: String
var curr_hair: int = 0
var curr_eyes: int = 0
var curr_shirt: int = 0
var curr_pants: int = 0
var curr_shoes: int = 0
var curr_acc: int = 0
var curr_facial_hair: int = 0
var curr_skin_color: int = 0
var curr_hair_color: int = 0
var curr_facial_hair_color: int = 0
var skinColor: String
var hairColor: String
var facialHairColor: String

var shirt: String
var pants: String
var shoes: String

var noShirt: String = "No Shirt"
var blueJacket: String = "Blue Jacket"
var blackShirt: String = "Black Shirt"
var redShirt: String = "Red Shirt"

var noPants: String = "No Pants"
var blackJeans: String = "Black Jeans"
var blueJeans: String = "Blue Jeans"

var noShoes: String = "No Shoes"
var blueShoes: String = "Blue Shoes"
var blackShoes: String = "Black Shoes"
var redShoes: String = "Red Shoes"

var rng = RandomNumberGenerator.new()

func _ready():
	bodySprite.texture = composite_sprites.body_spritesheet[0]
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]
	pantsSprite.texture = composite_sprites.pants_spritesheet[curr_pants]
	shirtSprite.texture = composite_sprites.shirt_spritesheet[curr_shirt]
	shoesSprite.texture = composite_sprites.shoes_spritesheet[curr_shoes]
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[curr_acc]
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[curr_facial_hair]
	
	#Default skin color
	skinColor = String('ffffff')
	bodySprite.modulate = skinColor
	
	#Defualt hair color
	hairColor = String('3a2b16')
	hairSprite.modulate = hairColor
	
	#Defualt facial har color
	facialHairColor = String('3a2b16')
	facialHairSprite.modulate = facialHairColor
	
	#Hides player shadow
	get_parent().get_node("Player/Shadow").hide()

func _on_ChangeHair_pressed():
	curr_hair = (curr_hair + 1) % composite_sprites.hair_spritesheet.size()
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]

func _on_ChangeEyes_pressed():
	curr_eyes = (curr_eyes + 1) % composite_sprites.eyes_spritesheet.size()
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]

func _on_ChangeShirt_pressed():
	curr_shirt = (curr_shirt + 1) % composite_sprites.shirt_spritesheet.size()
	shirtSprite.texture = composite_sprites.shirt_spritesheet[curr_shirt]
	if curr_shirt == 0:
		shirt = noShirt
	if curr_shirt == 1:
		shirt = blueJacket
	if curr_shirt == 2:
		shirt = blackShirt
	if curr_shirt == 3:
		shirt = redShirt
	print(curr_shirt)
	
func _on_ChangePants_pressed():
	curr_pants= (curr_pants + 1) % composite_sprites.pants_spritesheet.size()
	pantsSprite.texture = composite_sprites.pants_spritesheet[curr_pants]
	if curr_pants == 0:
		pants = noPants
	if curr_pants == 1:
		pants = blackJeans
	if curr_pants == 2:
		pants = blueJeans
	print(curr_pants)

func _on_ChangeShoes_pressed():
	curr_shoes = (curr_shoes + 1) % composite_sprites.shoes_spritesheet.size()
	shoesSprite.texture = composite_sprites.shoes_spritesheet[curr_shoes]
	if curr_shoes == 0:
		shoes = noShoes
	if curr_shoes == 1:
		shoes = blueShoes
	if curr_shoes == 2:
		shoes = blackShoes
	if curr_shoes == 3:
		shoes = redShoes
	print(curr_shoes)

func _on_ChangeFacialHair_pressed():
	curr_facial_hair = (curr_facial_hair + 1) % composite_sprites.facial_hair_spritesheet.size()
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[curr_facial_hair]

func _on_ChangeFacHair_pressed():
	curr_facial_hair = (curr_facial_hair + 1) % composite_sprites.facial_hair_spritesheet.size()
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[curr_facial_hair]
	
func _on_ChangeAcc_pressed():
	curr_acc = (curr_acc + 1) % composite_sprites.acc_spritesheet.size()
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[curr_acc]

func _on_RandomButton_pressed():
	#Get random number from spritesheets
	curr_acc = rng.randi_range(0, composite_sprites.acc_spritesheet.size() - 1)
	curr_hair = rng.randi_range(0, composite_sprites.hair_spritesheet.size() - 1)
	curr_eyes = rng.randi_range(0, composite_sprites.eyes_spritesheet.size() - 1)
	curr_shirt = rng.randi_range(0, composite_sprites.shirt_spritesheet.size() - 1)
	curr_pants = rng.randi_range(0, composite_sprites.pants_spritesheet.size() - 1)
	curr_shoes = rng.randi_range(0, composite_sprites.shoes_spritesheet.size() - 1)
	curr_facial_hair = rng.randi_range(0, composite_sprites.facial_hair_spritesheet.size() - 1)
	
	#Gets random colors
	curr_skin_color = rng.randi_range(0, composite_sprites.skin_colors.size() - 1)
	curr_hair_color = rng.randi_range(0, composite_sprites.hair_colors.size() - 1)
	curr_facial_hair_color = rng.randi_range(0, composite_sprites.facial_hair_spritesheet.size() - 1)
	
	#Sets texture of sprites
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[curr_acc]
	shirtSprite.texture = composite_sprites.shirt_spritesheet[curr_shirt]
	shoesSprite.texture = composite_sprites.shoes_spritesheet[curr_shoes]
	pantsSprite.texture = composite_sprites.pants_spritesheet[curr_pants]
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[curr_facial_hair]
	
	#Sets random colors
	skinColor = composite_sprites.skin_colors[curr_skin_color]
	bodySprite.modulate = skinColor
	
	hairColor = composite_sprites.hair_colors[curr_hair_color]
	hairSprite.modulate = hairColor
	
	facialHairColor = composite_sprites.hair_colors[curr_hair_color]
	facialHairSprite.modulate = facialHairColor
	
	#Checks to see if player equips any clothing
	
	#Shirts
	if curr_shirt == 0:
		shirt = noShirt
	if curr_shirt == 1:
		shirt = blueJacket
	if curr_shirt == 2:
		shirt = blackShirt
	if curr_shirt == 3:
		shirt = redShirt
	
	#Pants
	if curr_pants == 0:
		pants = noPants
	if curr_pants == 1:
		pants = blackJeans
	if curr_pants == 2:
		pants = blueJeans
		
	#Shoes
	if curr_shoes == 0:
		shoes = noShoes
	if curr_shoes == 1:
		shoes = blueShoes
	if curr_shoes == 2:
		shoes = blackShoes
	if curr_shoes == 3:
		shoes = redShoes
	
func _on_ConfirmButton_pressed():
	if playerName != "" and playerName[0] != " ": 
		get_tree().change_scene("res://World.tscn")
		DataManager.save_game(getAppearence())
	
func getAppearence():
	var save_dict = {
		"PlayerName": playerName,
		"Hair": curr_hair,
		"Eyes": curr_eyes,
		"Shirt": curr_shirt,
		"Pants": curr_pants,
		"FacialHair": curr_facial_hair,
		"Accessories": curr_acc,
		"Shoes": curr_shoes,
		"SkinColor": skinColor,
		"HairColor": hairColor,
		"FacialHairColor": facialHairColor,
		"PlayerShirtSlot": shirt,
		"PlayerPantsSlot": pants,
		"PlayerShoesSlot": shoes
	}
	return save_dict
	
func _on_ChangeHair2_pressed():
	curr_hair = fposmod(curr_hair - 1, composite_sprites.hair_spritesheet.size())
	hairSprite.texture = composite_sprites.hair_spritesheet[curr_hair]
	
func _on_ChangeEyes2_pressed():
	curr_eyes = fposmod(curr_eyes - 1, composite_sprites.eyes_spritesheet.size()) 
	eyesSprite.texture = composite_sprites.eyes_spritesheet[curr_eyes]

func _on_ChangeShirt2_pressed():
	curr_shirt = fposmod(curr_shirt - 1, composite_sprites.shirt_spritesheet.size())  
	shirtSprite.texture = composite_sprites.shirt_spritesheet[curr_shirt]
	if curr_shirt == 0:
		shirt = noShirt
	if curr_shirt == 1:
		shirt = blueJacket
	if curr_shirt == 2:
		shirt = blackShirt
	if curr_shirt == 3:
		shirt = redShirt
	
func _on_ChangePants2_pressed():
	curr_pants= fposmod(curr_pants - 1, composite_sprites.pants_spritesheet.size()) 
	pantsSprite.texture = composite_sprites.pants_spritesheet[curr_pants]
	if curr_pants == 0:
		shirt = noPants
	if curr_pants == 1:
		pants = blackJeans
	if curr_pants == 2:
		pants = blueJeans
	
func _on_ChangeShoes2_pressed():
	curr_shoes = fposmod(curr_shoes - 1, composite_sprites.shoes_spritesheet.size()) 
	shoesSprite.texture = composite_sprites.shoes_spritesheet[curr_shoes]
	if curr_shoes == 0:
		shoes = noShoes
	if curr_shoes == 1:
		shoes = blueShoes
	if curr_shoes == 2:
		shoes = blackShoes
	if curr_shoes == 3:
		shoes = redShoes

func _on_ChangeFacial2_pressed():
	curr_facial_hair = fposmod(curr_facial_hair - 1, composite_sprites.facial_hair_spritesheet.size())  
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[curr_facial_hair]

func _on_ChangeAcc2_pressed():
	curr_acc = fposmod(curr_acc - 1, composite_sprites.acc_spritesheet.size())  
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[curr_acc]

func _on_Button_pressed():
	get_tree().change_scene("res://Menu.tscn")
	
func _on_EnterName_text_changed(new_text):
	playerName = new_text

func _on_ChangeSkinColor_pressed():
	curr_skin_color = (curr_skin_color + 1) % composite_sprites.skin_colors.size()
	skinColor = composite_sprites.skin_colors[curr_skin_color]
	bodySprite.modulate = skinColor
	
func _on_ChangeHairColor_pressed():
	curr_hair_color = (curr_hair_color + 1) % composite_sprites.hair_colors.size()
	hairColor = composite_sprites.hair_colors[curr_hair_color]
	hairSprite.modulate = hairColor

func _on_ChangeFacialHairColor_pressed():
	curr_facial_hair_color = (curr_facial_hair_color + 1) % composite_sprites.hair_colors.size()
	facialHairColor = composite_sprites.hair_colors[curr_facial_hair_color]
	facialHairSprite.modulate = facialHairColor

func _on_ChangeSkinColor2_pressed():
	curr_skin_color = fposmod(curr_skin_color - 1, composite_sprites.skin_colors.size()) 
	skinColor = composite_sprites.skin_colors[curr_skin_color]
	bodySprite.modulate = skinColor

func _on_ChangeHairColor2_pressed():
	curr_hair_color = fposmod(curr_hair_color - 1, composite_sprites.hair_colors.size())  
	hairColor = composite_sprites.hair_colors[curr_hair_color]
	hairSprite.modulate = hairColor

func _on_ChangeFacialHairColor2_pressed():
	curr_facial_hair_color =  fposmod(curr_facial_hair_color - 1, composite_sprites.hair_colors.size()) 
	facialHairColor = composite_sprites.hair_colors[curr_facial_hair_color]
	facialHairSprite.modulate = facialHairColor

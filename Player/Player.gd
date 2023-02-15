extends KinematicBody2D

var data = null
var AttackPoints = 1

const composite_sprites = preload("res://CompositeSprites.gd")

#Get access to player customizations options
onready var bodySprite = get_parent().get_node("Player/Body")
onready var hairSprite = get_parent().get_node("Player/Hair")
onready var eyesSprite = get_parent().get_node("Player/Eyes")
onready var pantsSprite = get_parent().get_node("Player/Pants")
onready var shirtSprite = get_parent().get_node("Player/Shirt")
onready var shoesSprite = get_parent().get_node("Player/Shoes")
onready var accessoriesSprite = get_parent().get_node("Player/Accessories")
onready var facialHairSprite = get_parent().get_node("Player/FacialHair")

var skin_color: Color
var hair_color: Color
var facial_hair_color: Color

var shirtSlot
var pantsSlot
var shoesSlot

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
var ItemClass = preload("res://Item.gd").new()

export var ACCELERATION = 500
export var MAX_SPEED = 45
export var ROLL_SPEED = 120
export var FRICTION = 500

#Stores Player States
enum {
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE
var velocity = Vector2.ZERO #An X and Y pos combined
var roll_vector = Vector2.DOWN #Stores roll vector inside move state
var stats = PlayerStats #A global scene created in the auto load tab under Project

#Get access to other nodes
onready var animationPlayer = $AnimationPlayer #A dollar sign helps to get access to another node in the same child tree
onready var animationTree = $AnimationTree 
onready var animationState = animationTree.get("parameters/playback") #Gets access to the root in the animation tree
onready var attackHitbox = $HitBoxPivot/AttackHitbox 
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var timer = $Timer

#It will make it so animation tree is not active till game starts
func _ready():
	#Gets the customization data from the character creator menu
	data = DataManager.load_game()
	randomize() #So bats move in random directions
	stats.connect("no_health",self,"queue_free")
	animationTree.active = true
	attackHitbox.knockback_vector = roll_vector
	
	#Loads character customization choices
	hairSprite.texture = composite_sprites.hair_spritesheet[int(data["Hair"])]
	eyesSprite.texture = composite_sprites.eyes_spritesheet[int(data["Eyes"])]
	pantsSprite.texture = composite_sprites.pants_spritesheet[int(data["Pants"])]
	shirtSprite.texture = composite_sprites.shirt_spritesheet[int(data["Shirt"])]
	shoesSprite.texture = composite_sprites.shoes_spritesheet[int(data["Shoes"])]
	accessoriesSprite.texture = composite_sprites.acc_spritesheet[int(data["Accessories"])]
	facialHairSprite.texture = composite_sprites.facial_hair_spritesheet[int(data["FacialHair"])]
	
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

#Physics Process function is called every frame. Delta is how long the last frame took
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta) 
			#Player using items
			#If player is holding a healing potion
			if Globalvars.is_holding_healing_potion:
				if Input.get_action_strength("use_item"):
					pass
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		
#Player State Free
func move_state(delta):
	#Get player input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #Returns the vector scaled to the unit length of the player moving
	var run_key = Input.get_action_strength("Run")
	
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
		
	if Globalvars.in_inventory == false:
		#Player is moving
		if input_vector != Vector2.ZERO:
			#Animate Player
			roll_vector = input_vector #Declared roll vector here so player can't roll while not moving
			attackHitbox.knockback_vector = input_vector #This is so enemies move in all directions 

			#Sets blend position for animations
			animationTree.set("parameters/Idle/blend_position", input_vector) 
			animationTree.set("parameters/Walk/blend_position", input_vector) 
			animationTree.set("parameters/Attack/blend_position", input_vector) 
			animationTree.set("parameters/Roll/blend_position", input_vector) 
			animationTree.set("parameters/Run/blend_position", input_vector) 
			#Iron Sword blend positions
			animationTree.set("parameters/IdleWithIronSword/blend_position", input_vector)
			animationTree.set("parameters/RunWithIronSword/blend_position", input_vector)
			animationTree.set("parameters/WalkWithIronSword/blend_position", input_vector)
			
			animationTree.set("parameters/AttackWithIronSword1/blend_position", input_vector)
			animationTree.set("parameters/AttackWithIronSword2/blend_position", input_vector)
			animationTree.set("parameters/AttackWithIronSword3/blend_position", input_vector)
			#Steel Sword blend positions
			animationTree.set("parameters/IdleWithSteelSword/blend_position", input_vector)
			animationTree.set("parameters/WalkWithSteelSword/blend_position", input_vector)
			animationTree.set("parameters/RunWithSteelSword/blend_position", input_vector)
			
			animationTree.set("parameters/AttackWithSteelSword1/blend_position", input_vector)
			animationTree.set("parameters/AttackWithSteelSword2/blend_position", input_vector)
			animationTree.set("parameters/AttackWithSteelSword3/blend_position", input_vector)
			
			#If player is not holding a iron sword
			if Globalvars.is_holding_iron_sword == false:
				animationState.travel("Walk")
			
			#If player is holding a iron sword
			else:
				animationState.travel("WalkWithIronSword")
				
			#If player is holding a steel sword
			if Globalvars.is_holding_steel_sword == true:
				animationState.travel("WalkWithSteelSword")
				
			#Make sure velocity never goes faster than max speed
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
			#If player runs
			if stats.stamina > 0:
				if run_key:
					#If player is not holding a weapon
					if Globalvars.is_holding_iron_sword == false:
						if Globalvars.is_holding_steel_sword == false:
							animationState.travel("Run")
							MAX_SPEED = 80 #Sets MAX SPEED to 80 when running
							#Player loses stamina
							stats.stamina-=0.08
							#Sets stamina back to 0 if it goes negative
							if stats.stamina <= 0:
								MAX_SPEED = 45 #Sets MAX SPEED back to 45 when walking
								stats.stamina = 0
						#If player is holding a steel sword
						else:
							if Globalvars.is_holding_steel_sword == true:
								animationState.travel("RunWithSteelSword")
								MAX_SPEED = 80 #Sets MAX SPEED to 80 when running
								#Player loses stamina
								stats.stamina-=0.08	
								#Sets stamina back to 0 if it goes negative
								if stats.stamina <= 0:
									MAX_SPEED = 45 #Sets MAX SPEED back to 45 when walking
									stats.stamina = 0
					#If player is holding a iron sword
					else:			
						if Globalvars.is_holding_iron_sword == true:
							animationState.travel("RunWithIronSword")
							MAX_SPEED = 80 #Sets MAX SPEED to 80 when running
							#Player loses stamina
							stats.stamina-=0.08	
							#Sets stamina back to 0 if it goes negative
							if stats.stamina <= 0:
								MAX_SPEED = 45 #Sets MAX SPEED back to 45 when walking
								stats.stamina = 0
				#Player gains stamina when walking
				else:
					stats.stamina += 0.2
					#Sets stamina back to 100 if it goes above 100
					if stats.stamina >= 100:
						stats.stamina = 100
					MAX_SPEED = 45 #Sets MAX SPEED back to 45 when walking
						
		#Player is not moving
		else:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			#Player gains stamina when not moving
			stats.stamina += 0.2
			#Sets stamina back to 100 if it goes above 100
			if stats.stamina >= 100:
				stats.stamina = 100
				
			#If player is holding iron sword
			if Globalvars.is_holding_iron_sword == true:
				animationState.travel("IdleWithIronSword")
			
			#If player is holding steel sword
			if Globalvars.is_holding_steel_sword == true:
				animationState.travel("IdleWithSteelSword")

		move() #Moves player along the vector
		
		#If player rolls
		if stats.stamina >= 21.7:
			if Input.is_action_just_pressed("roll"):
				state = ROLL
		
		#If player attacks
		if stats.stamina >= 10:
			if Input.is_action_just_pressed("attack"):
				state = ATTACK
				
#Roll State
func roll_state():
	velocity = roll_vector * ROLL_SPEED #Velocity when rolling
	animationState.travel("Roll")
	move() #Moves player along the vector
	stats.stamina-=0.7	
	#Sets stamina back to 0 if it goes negative
	if stats.stamina <= 0:
		stats.stamina = 0
	
#Attack State	
func attack_state():
	velocity = Vector2.ZERO #So player does not slide after attacking
	#Checks to see if player is not holding any weapon
	if Globalvars.is_holding_iron_sword == false:
			if Globalvars.is_holding_steel_sword == false:
				#Melee attack
				animationState.travel("Attack")
				stats.stamina -= 0.15
			#If player is wielding steel sword
			else:
				if AttackPoints == 1:
					stats.stamina -= 6
					timer.start()
					state = animationState.travel("AttackWithSteelSword1")
					AttackPoints += 1
				elif AttackPoints == 2:
					stats.stamina -= 4
					timer.start()
					state = animationState.travel("AttackWithSteelSword2")
					AttackPoints += 1
				elif AttackPoints == 3:
					stats.stamina -= 4
					timer.start()
					state = animationState.travel("AttackWithSteelSword3")
					AttackPoints += 1
				elif AttackPoints == 4:
					AttackPoints = 1
	#If player is wielding iron sword
	else:
		if AttackPoints == 1:
			stats.stamina -= 6
			timer.start()
			state = animationState.travel("AttackWithIronSword1")
			AttackPoints += 1
		elif AttackPoints == 2:
			stats.stamina -= 4
			timer.start()
			state = animationState.travel("AttackWithIronSword2")
			AttackPoints += 1	
		elif AttackPoints == 3:
			stats.stamina -= 4
			timer.start()
			state = animationState.travel("AttackWithIronSword3")
			AttackPoints += 1
		elif AttackPoints == 4:
			AttackPoints = 1
		
func _on_Timer_timeout():
	AttackPoints = 1
	
func move():
	#Velocity will be relative to the frame rate when multipled by delta
	velocity = move_and_slide(velocity) #Moves player along the vector
	
func roll_animation_finished():
	velocity = velocity * 0.5 #So player does not slide as much after rolling
	state = MOVE

#Once attack animation is finished, player can move again
func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6) #Player gets half a second of invinciblity when hit
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	
	#Shakes screen if player gets hit
	Shake.shake(5 * area.damage/12,0.2)
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
#	bodySprite.modulate = Color(255,255,255,255)
#	hairSprite.modulate = Color('ffffff')
#	facialHairSprite.modulate = Color('ffffff')

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
#	bodySprite.modulate = skin_color
#	hairSprite.modulate = hair_color
#	facialHairSprite.modulate = facial_hair_color

#Pick up an item on the ground
func _input(_event):
	#Checks to see if it has any items in the pick up zone
	if $PickupZone.items_in_range.size() > 0:
		#picks up item by calling the back up item within the item drop script
		var pickup_item = $PickupZone.items_in_range.values()[0]
		pickup_item.pick_up_item(self)
		$PickupZone.items_in_range.erase(pickup_item)

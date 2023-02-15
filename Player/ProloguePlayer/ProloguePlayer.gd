extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 45
export var ROLL_SPEED = 120
export var FRICTION = 500

var AttackPoints = 1

#Stores Player States
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO #An X and Y pos combined
var stats = PlayerStats #A global scene created in the auto load tab under Project
var roll_vector = Vector2.DOWN #Stores roll vector inside move state

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationState = animationTree.get("parameters/playback")
onready var attackHitbox = $HitBoxPivot/AttackHitbox 
onready var hurtbox = $Hurtbox
onready var timer = $Timer

func _ready():
	attackHitbox.knockback_vector = roll_vector
	animationTree.active = true
	stats.connect("no_health",self,"queue_free")
	Globalvars.prologuePlayer = self
	
func _exit_tree():
	Globalvars.prologuePlayer = null

func _physics_process(delta):
	match state:
		MOVE:
			if Globalvars.inCutscene == false:
				move_state(delta)
		ROLL:
			if Globalvars.inCutscene == false:
				roll_state()
		ATTACK:
			if Globalvars.inCutscene == false:
				attack_state()
			
func move_state(delta):
	#Get player input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() #Returns the vector scaled to the unit length of the player moving
	
	stats.stamina += 0.2
	if stats.stamina >= 100:
		stats.stamina = 100
		
	#Player is moving
	if input_vector != Vector2.ZERO:
		attackHitbox.knockback_vector = input_vector
		roll_vector = input_vector #Declared roll vector here so player can't roll while not moving
		#Sets blend position for animations
		animationTree.set("parameters/Idle/blend_position", input_vector) 
		animationTree.set("parameters/Run/blend_position", input_vector) 
		animationTree.set("parameters/Roll/blend_position", input_vector) 
		animationTree.set("parameters/Attack/blend_position", input_vector) 
		animationTree.set("parameters/Attack2/blend_position", input_vector) 
		animationTree.set("parameters/Attack3/blend_position", input_vector) 
		animationState.travel("Run")
		
		#Make sure velocity never goes faster than max speed
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			
	#Player is not moving
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move() #Moves player along the vector
	
	#If player rolls
	if stats.stamina >= 21.7:
		if Input.is_action_just_pressed("roll"):
			state = ROLL
			
	#If player attacks
	if stats.stamina >= 10:
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
		
func move():
	#Velocity will be relative to the frame rate when multipled by delta
	velocity = move_and_slide(velocity) #Moves player along the vector
	
func attack_animation_finished():
	state = MOVE
	
func attack_state():
	velocity = Vector2.ZERO #So player does not slide after attacking
	#Checks to see if player is not holding any weapon
	if AttackPoints == 1:
		stats.stamina -= 6
		timer.start()
		state = animationState.travel("Attack")
		AttackPoints += 1
	elif AttackPoints == 2:
		stats.stamina -= 4
		timer.start()
		state = animationState.travel("Attack2")
		AttackPoints += 1
	elif AttackPoints == 3:
		stats.stamina -= 4
		timer.start()
		state = animationState.travel("Attack3")
		AttackPoints += 1
	elif AttackPoints == 4:
		AttackPoints = 1

func _on_Timer_timeout():
	AttackPoints = 1
	
#Roll State
func roll_state():
	velocity = roll_vector * ROLL_SPEED #Velocity when rolling
	animationState.travel("Roll")
	move() #Moves player along the vector
	stats.stamina-=0.7	
	#Sets stamina back to 0 if it goes negative
	if stats.stamina <= 0:
		stats.stamina = 0
		
func roll_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6) #Player gets half a second of invinciblity when hit
	hurtbox.create_hit_effect()
	
	Shake.shake(3,0.2)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
	get_tree().change_scene("res://PrologueCastle02.tscn")

extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 30
export var FRICTION = 350
export var WANDER_TARGET_RANGE = 4

#State machines
enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var blood = load("res://Effects/Blood.tscn")

var state = CHASE

onready var stats = $Stats #Gives bat access to stats
onready var playerDetectionZone = $PlayerDetectionZone #Get access to node
onready var playerAttackZone = $PlayerAttackZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationTree = $AnimationTree 
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta): 
   
	if playerAttackZone.can_see_player():
		state = ATTACK
		
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta ) 
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			MAX_SPEED = 30
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			MAX_SPEED = 30
			animationState.travel("Walk")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()	
			accelerate_towards_point(wanderController.target_position, delta)#Gets player direction
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			velocity = move_and_slide(velocity, Vector2.ZERO)
				
		CHASE:
			if Globalvars.player_attack_zone == false:
				MAX_SPEED = 50
				animationState.travel("Run")
				#Guard chases player when they are seen
				var player = playerDetectionZone.player 
			
				#If guard sees player
				if player != null:
					accelerate_towards_point(player.global_position, delta) #Gets player direction
					velocity = move_and_slide(velocity, Vector2.ZERO)
					
				#If player escapes guard
				else:
					state = IDLE
				
		ATTACK:
			velocity = Vector2.ZERO
			animationState.travel("Attack")
			
	if velocity != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", velocity)
		animationTree.set("parameters/Walk/blend_position", velocity)
		animationTree.set("parameters/Run/blend_position", velocity)
		animationTree.set("parameters/Attack/blend_position", velocity)

func attack_animation_finished():
	state = WANDER
	
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE 
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3)) 
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point) #Gets player direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 160
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	var blood_instance = blood.instance()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	blood_instance.rotation = global_position.angle_to_point(Globalvars.prologuePlayer.global_position)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

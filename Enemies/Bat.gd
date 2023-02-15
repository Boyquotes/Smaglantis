extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 350
export var WANDER_TARGET_RANGE = 4

#State machines
enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats #Gives bat access to stats
onready var playerDetectionZone = $PlayerDetectionZone #Get access to node
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):                                     
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta ) #Friction when bat is being knocked back
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) 
			seek_player()	
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()	
			accelerate_towards_point(wanderController.target_position, delta)#Gets player direction			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
				
		CHASE:
			#Bat chases player when they are seen
			var player = playerDetectionZone.player 
			#If bat sees player
			if player != null:
				accelerate_towards_point(player.global_position, delta)#Gets player direction				
			#If player escapes bat
			else:
				state = IDLE
			
	#if multiple bats collide together they will be pushed away from each other
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point) #Gets player direction
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0 
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE #chases player if bat sees them
		
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3)) 
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
#Bat taking damage
func _on_Hurtbox_area_entered(area):
	if Globalvars.is_holding_iron_sword == false:
		if Globalvars.is_holding_steel_sword == false:
			stats.health -= area.damage
			knockback = area.knockback_vector * 150 #Bat being knocked back 
			hurtbox.create_hit_effect()
			hurtbox.start_invincibility(0.4)
		#If bat is being hit by a steel sword
		else:
			stats.health -= 5
			knockback = area.knockback_vector * 150 #Bat being knocked back 
			hurtbox.create_hit_effect()
			hurtbox.start_invincibility(0.4)
	#If bat is being hit by a iron sword
	else:
		stats.health -= 3
		knockback = area.knockback_vector * 150 #Bat being knocked back 
		hurtbox.create_hit_effect()
		hurtbox.start_invincibility(0.4)

#Checks if bat has 0 health
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

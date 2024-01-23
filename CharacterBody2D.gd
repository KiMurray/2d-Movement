extends CharacterBody2D

@export var dash_component : DashComponent 


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bounce_learned = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1200
var direction : Vector2
var is_busy : bool = false #Char performing action eg dash
var is_gravity : bool = true #Set to false on dash but not on ghost

func _physics_process(delta):
	if Input.is_action_just_pressed("test"):
		get_tree().reload_current_scene()
		
	if is_gravity:
		if velocity.x > 800:
			velocity.x = 800
		if velocity.x < -800:
			velocity.x = -800
		
		if velocity.y > 800:
			velocity.y = 800
		if velocity.y < -800:
			velocity.y = -800
	# Add the gravity.
	if not is_on_floor() and is_gravity:
		velocity.y += gravity * delta
	
	#get player direction
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Handle jump.
	
	
	
	if Input.is_action_just_pressed("ui_accept") and not is_busy: #TODO Celeste wave dash
		if is_on_floor():
			jump()
		else:
			$PreJumpTimer.start()
	if is_on_floor() and $PreJumpTimer.time_left > 0:
		jump()
		$PreJumpTimer.stop()
	
	#Slow player down in air and on ground
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_on_floor():
		if direction and not is_busy:
			velocity.x = direction * SPEED # move along ground
		else:# either dir is null or is busy
			velocity.x = move_toward(velocity.x, 0, SPEED/10) #friction on floor
	else:# not on floor
		if direction and not is_busy: 
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/10)  #friction in air by player
		else: # either dir is null or is busy
			velocity.x = move_toward(velocity.x, 0, SPEED/20) # friction in air alone
	move_and_slide()
	#elif not is_on_floor() and bounce_learned: # Dashing and on floor
		#var collision_info = move_and_collide(velocity * delta)
		#if not collision_info: return
		#velocity = velocity.bounce(collision_info.get_normal())
		#velocity.x *= 2
		#dash_component.can_dash = true
	#else:
		#move_and_slide()
		
		
func jump():
	print("jumping")
	velocity.y = JUMP_VELOCITY
	
func _ready(): 
	dash_component.dash_learned = false


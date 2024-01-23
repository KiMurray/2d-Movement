extends CharacterBody2D
class_name SpritComponent

var is_spirit : bool = true
var gravity = 800

const SPEED = 500
const JUMP_VELOCITY = -400
@export var char : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input TOGGLE is_Spirit
	if is_spirit:
		# Gravity
		if not is_on_floor():
			velocity.y += gravity * delta
		
		if not char.is_busy:
			char.is_busy = true
			
		var direction = Input.get_axis("ui_left", "ui_right")
		if is_on_floor(): 
			if direction:
				velocity.x = direction * SPEED # move along ground
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED/10) #friction on floor
		else:# not on floor
			if direction: 
				velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/10)  #friction in air by player
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED/20) # friction in air alone
				
				
				
		if Input.is_action_just_pressed("ui_accept"): 
			if is_on_floor():
				jump()
		move_and_slide()

func jump():
	print("jumping")
	velocity.y = JUMP_VELOCITY

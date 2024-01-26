extends CharacterBody2D
class_name SpritComponent

var is_spirit : bool = false
var gravity = 800
var knight_to_ghost_vector: Vector2
var can_move = true
var tether_stretch = 0
var max_tether_stretch = 30
var prev_dir
var is_flinging = false
var fling_learned = true


const TETHER_RANGE = 200
const SPEED = 500
const JUMP_VELOCITY = -400
@export var knight : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	if is_spirit:
		draw_line(-position, Vector2.ZERO, Color.RED, 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Spirit Toggle
	
	toggle_spirit_listener()
	visible = is_spirit
	#_draw()
	if is_spirit:
		queue_redraw()
	if is_spirit and can_move:
		knight.can_move = false
		
		# Set vars
		jump_listener()
		gravity_process(delta)
		
		var direction = Input.get_axis("ui_left", "ui_right")
		
		if is_on_floor(): 
			if not is_flinging:
				if direction:
					if position.length() > TETHER_RANGE:
						if fling_learned:
							tether_stretch = min(tether_stretch +1, max_tether_stretch)
					velocity.x = direction * SPEED  # move along ground
					prev_dir = direction
				else:
					if tether_stretch > 0: #Fling must be learned for > 0
						$FlingTimer.start()
						can_move = false
						is_flinging = true
						velocity.x =  500 * -prev_dir
						tether_stretch -= 1
						print(velocity.x, "   ", tether_stretch)
					else:
						velocity.x = move_toward(velocity.x, 0, SPEED/10) #friction on floor
						tether_stretch = 0
			else: #Flinging
				pass
				#velocity.x = 1000 * prev_dir
		else:# not on floor
			if direction: 
				velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/10)  #friction in air by player
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED/20) # friction in air alone
		
		#print("before",position.length())
		position = position.limit_length(TETHER_RANGE + tether_stretch)
		#print(position.length())
		
	move_and_slide()
		#print(position.length())
		
	# End of process
	pass
	
func jump_listener():
	if Input.is_action_just_pressed("ui_accept"): 
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			$PreJumpTimer2.start()
	# Jump helper
	if is_on_floor() and $PreJumpTimer2.time_left > 0:
		velocity.y = JUMP_VELOCITY
		$PreJumpTimer2.stop()
		
func toggle_spirit_listener():
	if Input.is_action_just_pressed("switch"):
		if is_spirit:
			#set spirit to be knight position
			position = Vector2(0,0)
			visible = false
			is_spirit = false
		else:
			#Transform into spirit
			is_spirit = true
			velocity = Vector2(knight.velocity.x, min(0, knight.velocity.y))
		knight.can_move = !is_spirit ## TODO Remove this?
func gravity_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_fling_timer_timeout():
	print("I am timiing out ")
	is_flinging = false
	can_move = true
	tether_stretch = 0
	pass

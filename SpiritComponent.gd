extends CharacterBody2D
class_name SpiritComponent

var is_spirit : bool = false
var is_untethered : bool = false
var gravity = 1200
var knight_to_ghost_vector: Vector2
var can_move = true
var tether_stretch = 0
var max_tether_stretch = 30
var prev_dir
var is_flinging = false
var fling_learned = false
var direction
#a mode where ghost has no g. if no dir always friction
var ghost_grav = true

var full_texture : Texture2D = load("res://Assets/Characters/Full-Knight.png")

const TETHER_RANGE = 200
const SPEED = 500
const JUMP_VELOCITY = -600
@export var knight : KnightComponent
@export var dash_component : DashComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Spirit Toggle
	
	if Input.is_action_just_pressed("switch"):
		ghost_switch()
	visible = is_spirit
	
	
	if is_spirit and can_move:
		knight.can_move = false
		
		# Set vars
		jump_listener()
		gravity_process(delta)
		handle_movement()
		
		
		
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
		
func ghost_switch():
	if is_spirit: ## switching back to knight
		knight.change_texture(0)
		position = knight.position
		visible = false
		is_spirit = false
	else:#Transform into spirit
		knight.change_texture(1)
		position = knight.position
		is_spirit = true
		velocity.y = min(0, knight.velocity.y)
	knight.can_move = !is_spirit ## TODO Remove this?
func gravity_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
func handle_movement():
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	handle_sprite_flip()
	if is_on_floor(): 
		if not is_flinging:
			if direction.x:
				if position.length() > TETHER_RANGE:
					if fling_learned:
						tether_stretch = min(tether_stretch +1, max_tether_stretch)
				velocity.x = direction.x * SPEED  # move along ground
				prev_dir = direction.x
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
			velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED/10)  #friction in air by player
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/20) # friction in air alone
	
	var limit_dist_between_chars = (position).limit_length(200)
	if limit_dist_between_chars.length() > 201:
		print(limit_dist_between_chars.length())
		return
		
	var prev_pos = position
	var prev_velocity = velocity
	move_and_slide()
	if not is_untethered:
		position =  (position - knight.position).limit_length(200) + knight.position

func _on_fling_timer_timeout():
	print("I am timiing out ")
	is_flinging = false
	can_move = true
	tether_stretch = 0
	pass

func handle_sprite_flip():
	if can_move:
		if direction.x > 0:
			$Sprite2D.flip_h = false
		elif direction.x < 0:
			$Sprite2D.flip_h = true
	pass

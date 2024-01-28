extends Node2D
class_name DashComponent

const UP_RIGHT = Vector2(sqrt(2)/2, -sqrt(2)/2)
const UP_LEFT = Vector2(-sqrt(2)/2, -sqrt(2)/2)
const DOWN_RIGHT = Vector2(sqrt(2)/2, sqrt(2)/2)
const DOWN_LEFT = Vector2(-sqrt(2)/2, sqrt(2)/2)
const RIGHT = Vector2(1,0)
const LEFT = Vector2(-1,0)
const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const DASH_SPEED = 500
var dash_learned : bool = false
var is_dashing : bool = false
var can_dash : bool = false

var reduce_speed = true
var dash_direction

@export var char : KnightComponent

func dash_listener(direction : Vector2, input : String, is_on_floor : bool):
	if Input.is_action_just_pressed(input) and can_dash and not is_dashing and not is_on_floor and dash_learned:
		print("pressed")
		direction = round_direction(round(rad_to_deg(-direction.angle())))
		dash_direction = direction
		if not direction == Vector2(0,0):
			$DashTimer.start()
			is_dashing = true
			char.is_busy = true
			can_dash = false
			char.velocity = direction * DASH_SPEED * 2 

func round_direction(deg : float) -> Vector2:
	if deg == -180:
		deg = 180
	if deg < 0: 
		# Convert to 0 to 360 scale
		deg = 360 - (deg * -1) 
	var segment : int = ceil(deg / 22.5)
	match segment:
		0, 1:
			return RIGHT
		2, 3: 
			return UP_RIGHT
		4, 5: 
			return UP
		6, 7: 
			return UP_LEFT
		8, 9:
			return LEFT 
		10, 11: 
			return DOWN_LEFT
		12, 13:
			return DOWN
		14, 15:
			return DOWN_RIGHT
	print("Error: no case deg:", deg, " segment: ", segment)
	return Vector2(0,0)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if char.is_on_floor():
		can_dash = true
		$DashTimer.start(0.25)
	dash_listener(char.direction, "dash", char.is_on_floor())
	
 
func _on_dash_timer_timeout():
	is_dashing = false
	char.can_move = true
	
func cancel_dash():
	is_dashing = false
	char.can_move = true
	$DashTimer.stop()

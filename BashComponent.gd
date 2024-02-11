extends Node2D
class_name BashComponent

const BASH_SPEED = 750

var is_bashing : bool = false
var bash_vector : Vector2
var bash_learned = true
var can_bash = false

@export var knight : KnightComponent
@export var spirit : SpiritComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_bashing:
		knight.velocity = BASH_SPEED * bash_vector
		can_bash = false

	
	handle_bash()


func handle_bash():
	if not bash_learned or not spirit.is_spirit or spirit.is_untethered:# or is_bashing: #Check if ability learned
		return
	if knight.is_on_floor() and not can_bash and not is_bashing:
		can_bash = true
	if Input.is_action_just_pressed("dash") and can_bash and not spirit.is_untethered:
		print("ashjdfjkasd")
		spirit.can_move = false
		# Trigger movement before bash
		#knight.position = spirit.position
		knight.change_texture(0)
		
		spirit.is_spirit = false
		knight.velocity = spirit.velocity
		
		bash_vector = Vector2(1, 0).rotated((-knight.position + spirit.position).angle())
		
		spirit.position = knight.position
		$BashTimer.start()
		is_bashing = true
		
		pass

func _on_bash_timer_timeout():
	is_bashing = false
	print("timeout")
	knight.can_move = true
	spirit.can_move = true

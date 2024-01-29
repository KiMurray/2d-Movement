extends Node2D
class_name BashComponent

const BASH_SPEED = 750

var is_bashing : bool = false
var bash_vector : Vector2
var bash_learned = true


@export var knight : CharacterBody2D
@export var spirit : SpiritComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_bash()


func handle_bash():
	if not bash_learned:# or is_bashing: #Check if ability learned
		return
	if is_bashing:
		#print(knight.position, "    ", knight.velocity)
		knight.velocity = BASH_SPEED * bash_vector
		#print(knight.position, "    ", knight.velocity)
		#print(bash_vector)
		pass
	 
	if Input.is_action_just_pressed("RB") and spirit.is_spirit:
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

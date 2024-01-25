extends Node2D
class_name BashComponent

const BASH_SPEED = 1000

var is_bashing : bool = false
var bash_vector : Vector2

@export var knight : CharacterBody2D
@export var spirit : SpritComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_bash()


func handle_bash():
	if is_bashing:
		knight.velocity = BASH_SPEED * bash_vector
		pass
		
		
	
	if Input.is_action_just_pressed("RB"):
		# Trigger movement before bash
		var offset = 0
		if spirit.is_on_floor():
			offset = -10
			print("offset")
		knight.position += spirit.position + Vector2(0,offset)
		
		spirit.is_spirit = false
		knight.velocity = spirit.velocity
		
		bash_vector = Vector2(1, 0).rotated(spirit.position.angle())
		#if bash_angle < 0:
			#bash_angle += 2*PI 
		spirit.position = Vector2.ZERO
		$BashTimer.start(0.2)
		is_bashing = true
		#print(knight.position)
		pass

func _on_bash_timer_timeout():
	is_bashing = false

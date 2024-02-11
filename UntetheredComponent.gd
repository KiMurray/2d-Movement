extends Node2D

@export var spirit : SpiritComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spirit.is_spirit:
		if Input.is_action_just_pressed("untether"):
			spirit.is_untethered = true
			$Timer.one_shot = true
			$Timer.start(1)
		if Input.is_action_just_pressed("switch") and spirit.is_untethered:
			_on_timer_timeout()
	pass

	
	
func _on_timer_timeout():
	#if spirit.dash_component.is_dashing : _on_timer_timeout()
	spirit.is_untethered = false
	$Timer.stop()
	if spirit.is_spirit:
		spirit.ghost_switch()
	pass # Replace with function body.
	

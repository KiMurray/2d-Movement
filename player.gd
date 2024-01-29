extends Node2D

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Spirit.is_spirit:
		$Spirit.position = ($Spirit.position - $Knight.position).limit_length(200) + $Knight.position
		#print($Spirit.position)
		queue_redraw()
	pass

func _draw():
	if $Spirit.is_spirit:
		draw_line($Spirit.position, $Knight.position,  Color.RED, 10)
	

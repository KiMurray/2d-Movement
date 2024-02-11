extends Node2D

# Called when the node enters the scene tree for the first time.
var limit_dist_between_chars

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Spirit.is_spirit and not $Spirit.is_untethered:
		limit_dist_between_chars = ($Spirit.position - $Knight.position).limit_length(200)
		$Spirit.position = limit_dist_between_chars + $Knight.position
		#at max tether spirit loses speed away from knight due to tether
		if limit_dist_between_chars.length() > 200:
			$Spirit.velocity = $Spirit.velocity.limit_length(500)
			
		#print($Spirit.position)
		queue_redraw()
	pass

func _draw():
	if $Spirit.is_spirit and not $Spirit.is_untethered:
		draw_line($Spirit.position, $Knight.position,  Color.RED, 10)
	

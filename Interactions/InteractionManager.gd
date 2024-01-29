extends Node2D

@onready var knight = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const BASE_TEXT = "Press [E] to "

# array of all interactive areas our player intersects
var active_areas : Array = []

var can_interact = true

func add_area(area : InteractionArea):
	active_areas.push_back(area)
	
func remove_area(area : InteractionArea):
	var index = active_areas.find(area)
	if index != -1: 
		active_areas.remove_at(index)
		

func _process(delta):
	
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_knight)
		label.text = BASE_TEXT + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.position.y -= 36
		label.global_position.x -= label.size.x /2
		label.show()
	else:
		label.hide()
		
		
func _sort_by_distance_to_knight(area1 : InteractionArea, area2 : InteractionArea):
	var area1_to_knight = knight.global_position.distance_to(area1.global_position)
	var area2_to_knight = knight.global_position.distance_to(area2.global_position)
	# If true, b after a. We want lowest pos first. Therefore ... 
	return area1_to_knight < area2_to_knight
	
func _input(event):
	if event.is_action_pressed("Interact") and can_interact:
		if active_areas.size():
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			can_interact = true

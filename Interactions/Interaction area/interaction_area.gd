extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass

func _on_body_entered(body):
	print("enter ")
	InteractionManager.add_area(self) # Replace with function body.
	pass

func _on_body_exited(body):
	InteractionManager.remove_area(self)
	pass

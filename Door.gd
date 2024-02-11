extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$InteractionArea.interact = Callable(self, "_on_interact")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_interact():
	print(" yo dawgggg")
	$StaticBody2D/CollisionShape2D.disabled = !$StaticBody2D/CollisionShape2D.disabled
	self.visible = !self.visible
	pass

extends AnimatableBody2D

func _physics_process(delta: float) -> void:
	self.rotate(delta * PI * 1.05)

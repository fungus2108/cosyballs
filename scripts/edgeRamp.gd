extends Area2D

@onready var forceDirection = $forceDirection.global_position

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			var forceVector = self.global_position - forceDirection
			var force = forceVector.normalized() * 8000
			body.apply_force(-force * delta)

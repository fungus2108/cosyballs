extends Area2D

@export var fanForce = 8e6
@export var fanRotation = 2 * PI

func _process(delta: float) -> void:
	$Sprite2D.rotate(fanRotation * delta)


func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			# Pushes ball away; force is inversely proportional to its distance from fan centre
			var forceVector = self.global_position - body.position
			var force = forceVector.normalized() * (fanForce / maxf(1, forceVector.length()))
			body.apply_force(-force * delta)

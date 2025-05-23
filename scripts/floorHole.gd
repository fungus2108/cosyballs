extends Area2D

var totalBallInstances

var levelBeaten = false


func _ready() -> void:
	# fetches the total number of balls in the level from the level script
	await get_tree().physics_frame
	
	totalBallInstances = $"..".ballInstances


func _physics_process(delta: float) -> void:
	if totalBallInstances == 0:
		if not levelBeaten:
			levelBeaten = true
			LevelManager.levelSwitch()


func _on_body_entered(body: Node2D) -> void:
	# checks if the body is a Ball (it's the only RigidBody2D in the game)
	if body is RigidBody2D:
		body.set_collision_layer_value(1, false)
		body.set_collision_mask_value(1, false)

		# schlorp them toward the center of the hole
		var impulseVec = (self.global_position - body.position) * 15.0
		body.apply_impulse(impulseVec)
		
		# after timeout they're frozen to not move
		await get_tree().create_timer(0.05).timeout
		body.freeze = true
	
		body.holeColouring(0.6)


func _on_level_boundary_body_exited(body: Node2D) -> void:
	# this is a signal sent by the level boundary if an object has left, either by holing or OOB
	if body is RigidBody2D:
		totalBallInstances -= 1


func _on_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:	
		pass
		
	

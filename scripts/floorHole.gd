extends Area2D

var totalBallInstances
var ballCounter = 0.0

var levelBeaten = false


func _ready() -> void:
	# fetches the total number of balls in the level from the level script
	await get_tree().physics_frame
	
	totalBallInstances = $"..".ballInstances


func _physics_process(delta: float) -> void:
	if ballCounter == totalBallInstances:
		if not levelBeaten:
			levelBeaten = true
			LevelManager.levelSwitch()


func _on_body_entered(body: Node2D) -> void:
	# checks if the body is a Ball (it's the only RigidBody2D in the game)
	if body is RigidBody2D:
		# changes the collision detection so that hole balls dont effect unholed balls
		body.set_collision_layer(4)
		body.set_collision_mask(17)

		# schlorp them toward the center of the hole
		var impulseVec = (self.global_position - body.position) * 15.0
		body.apply_impulse(impulseVec)
		
		# after timeout they're frozen to not move
		await get_tree().create_timer(0.05).timeout
		body.set_freeze_enabled(true)
		
		ballCounter += 1
		
		var ballColour = ballCounter / totalBallInstances 
		body.holeColouring(maxf(ballColour, 0.5))

		
func _on_level_boundary_body_exited(body: Node2D) -> void:
	# this is a signal sent by the level boundary if an object has left
	if body is RigidBody2D:
		# if a ball has left the level just -1 from balls required. quick, easy, but dirty.
		totalBallInstances -= 1


func _on_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:	
		body.set_freeze_enabled(false)
		var impulseVec = (self.global_position - body.position) * 15.0
		body.apply_impulse(impulseVec)
		await get_tree().create_timer(0.1).timeout
		body.set_freeze_enabled(true)
		
		# randomly generates a point on the circle
		#var holeReturnVec = (Vector2($CollisionShape2D.shape.get_radius(), 0) * randf_range(0.0, 1.0)).rotated(randf_range(0, 2 * PI)) + self.global_position
		# body.position = holeReturnVec
	

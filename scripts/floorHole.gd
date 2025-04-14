extends Area2D

var totalBallInstances
var ballCounter = 0.0

func _ready() -> void:
	# fetches the total number of balls in the level from the level script
	await get_tree().physics_frame
	
	totalBallInstances = $"..".ballInstances

func _physics_process(delta: float) -> void:
	if ballCounter == totalBallInstances:
		get_tree().quit()


func _on_body_entered(body: Node2D) -> void:
	# checks if the body is a Ball (it's the only RigidBody2D in the game)
	if body is RigidBody2D:
		# stop the balls colliding with anything
		body.set_collision_layer(4)
		body.set_collision_mask(17)
		
		# schlorp them toward the center of the hole
		var impulseVec = (self.global_position - body.position) * 10.0
		body.apply_impulse(impulseVec)
		
		# after timeout they're frozen to not move
		await get_tree().create_timer(0.1).timeout
		body.set_freeze_enabled(true)
		
		ballCounter += 1
		
		var ballColour = ballCounter / totalBallInstances 
		body.holeColouring(maxf(ballColour, 0.4))


func _on_level_boundary_body_exited(body: Node2D) -> void:
	# this is a signal sent by the level boundary if an object has left
	if body is RigidBody2D:
		# if a ball has left the level just -1 from balls required. quick, easy, but dirty.
		totalBallInstances -= 1

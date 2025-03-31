extends Area2D

var totalBallInstances
var ballCounter = 0

func _ready() -> void:
	# fetches the total number of balls in the level from the level scripts
	totalBallInstances = $"..".ballInstances

func _physics_process(delta: float) -> void:
	if ballCounter == totalBallInstances:
		get_tree().quit()


func _on_body_entered(body: Node2D) -> void:
	# checks if the body is a Ball (it's the only RigidBody2D in the game)
	if body is RigidBody2D:
		body.set_freeze_enabled(true)
		body.set_collision_layer(2)
		body.set_collision_mask(6)

		ballCounter += 1

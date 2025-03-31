extends Node2D

var ballInstances = 1500

# get the ball
@export var ball : PackedScene
@onready var balls = []

@onready var spawnPosition = $Marker2D.position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		for i in ballInstances:
			var instance = ball.instantiate()
			instance.position = spawnPosition + Vector2(randi_range(-800, 800), randi_range(-500, 500))
			balls.append(instance)
			add_child(instance)
			

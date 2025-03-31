extends Node2D

var ballInstances = 1000

# get the ball
@export var ball : PackedScene
@onready var balls = []

@onready var spawnPosition = $ballSpawnMarker.position

func _physics_process(delta: float) -> void:
	pass
	

func _ready() -> void:
	await get_tree().physics_frame
	
	# we spawn da balls in a rectangle defined by the Vector2
	for i in ballInstances:
			var instance = ball.instantiate()
			instance.position = spawnPosition + Vector2(randi_range(-800, 800), randi_range(-480, 480))
			balls.append(instance)
			add_child(instance)

extends Node2D

@export var ball : PackedScene
@onready var balls = []

func _ready() -> void:
	# which level are we on :thinking:
	var ballInstances = 1200
	
	await get_tree().physics_frame
	
	# we spawn da balls in a rectangle defined by the Vector2
	for i in ballInstances:
			var instance = ball.instantiate()
			
			instance.position = $Marker2D.position + Vector2(randf_range(-900, 900), randf_range(-500, 500))
				
			balls.append(instance)
			add_child(instance)

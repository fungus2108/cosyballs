extends Marker2D

# get the ball
@export var ball : PackedScene
@onready var balls = []

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		for i in 2000:
			var instance = ball.instantiate()
			instance.position = Vector2(0, 0) + Vector2(randi_range(-600, 600), randi_range(-400, 400))
			balls.append(instance)
			add_child(instance)
			

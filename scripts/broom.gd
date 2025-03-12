extends AnimatableBody2D

@onready var rotationSpeed = 0.025

# variables for sweep tween (sween?) speed / time
@onready var isSweeping = false

@onready var sweepSpeed = 100.0

@onready var maxSweepTime = 1.0
@onready var minSweepTime = 0.55

@onready var maxSweepDistance = 250.0
@onready var minSweepDistance = 50.0

## draw_dashed_line <- VERY IMPORTANT REMEMBER THIS
## ALSO TO PICK UP AND MOVE BROOM FOR POSITIONING DO THE LERP TO MOUSE MOVEMENT THING!!!

func _physics_process(delta: float) -> void:
	# gets the mouse position so we can sweep the broom toward it and draw a direction guide
	var mousePosition = get_global_mouse_position()
	
	if Input.is_action_pressed("ui_right"):
		self.rotate(rotationSpeed)
	elif Input.is_action_pressed("ui_left"):
		self.rotate(-rotationSpeed)
		
	if Input.is_action_just_pressed("ui_up"):
		isSweeping = false
		
	if Input.is_action_just_pressed("sweep") and isSweeping == false:
		# make sure we can't do the dreaded double-sweep
		isSweeping = true
		
		# create a tween
		var sweepTween = get_tree().create_tween()
		
		# get the vector between the broom and the mouse
		var sweepVector = mousePosition - self.position
		
		# get the distance from the broom to the mouse and give it a min / max distance
		var totalDistance = position.distance_to(mousePosition)
		var tweenDistance = clampf(totalDistance, minSweepDistance, maxSweepDistance)
		
		# calculate the destination based off the normalised vector and calculated distance
		var sweepDestination = self.position + (sweepVector.normalized() * tweenDistance)
		var tweenSpeed = clampf(sweepSpeed / tweenDistance, minSweepTime, maxSweepTime)
		
		# tween me
		sweepTween.tween_property(self, "position", sweepDestination, tweenSpeed)
		
		# callback has to be an icky function (idk how to do anonymous functions)
		sweepTween.tween_callback(sweepTweenCallback)

func _draw():
	draw_circle(Vector2(0, 0), maxSweepDistance, Color(0.862745, 0.0784314, 0.235294, 1), false, 5.0)
	draw_circle(Vector2(0, 0), minSweepDistance, Color(0.862745, 0.0784314, 0.235294, 1), false, 5.0)

## Lets the player sweep again
func sweepTweenCallback():
	isSweeping = false

func customClamp(value: float):
	if value <= minSweepTime:
		return minSweepTime
	elif value >= maxSweepTime:
		return maxSweepTime
	else:
		return value

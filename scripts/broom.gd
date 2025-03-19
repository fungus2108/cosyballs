extends AnimatableBody2D

var rotationSpeed = 0.025

# variables for sweep tween (sween?) speed / time
var isSweeping = false

var sweepSpeed = 100.0

var maxSweepTime = 1.0
var minSweepTime = 0.75

var maxSweepDistance = 250.0
var minSweepDistance = 50.0

# variable for mouse interactions
var isMouseHovering = false
var isDragging = false

## ALSO TO PICK UP AND MOVE BROOM FOR POSITIONING DO THE LERP TO MOUSE MOVEMENT THING!!!

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("ui_right"):
		self.rotate(rotationSpeed)
	elif Input.is_action_pressed("ui_left"):
		self.rotate(-rotationSpeed)
		
	if Input.is_action_just_pressed("ui_up"):
		isSweeping = false

	# verifies if player is trying to move the object
	if isMouseHovering and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not isSweeping:
		isDragging = true
		
	if isDragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$CollisionShape2D.set_deferred("disabled", false)
		isDragging = false
		broomSweep()
		
		# gets rid of dashed line
		queue_redraw()
		
	if isDragging:
		$CollisionShape2D.set_deferred("disabled", true)
		var mousePosition = get_global_mouse_position()
		var directionVector =  mousePosition - self.position
		
		self.rotation = directionVector.angle()
		queue_redraw()
	
	# sets modulation
	if isDragging:
		$broomSprite.modulate = Color(0.95, 0.95, 0.95, 0.9)
	elif isMouseHovering:
		$broomSprite.modulate = Color(1.5, 1.5, 1.5, 1.0)
	else:
		$broomSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		
func _draw():
	if isDragging:
		var mousePosition = get_local_mouse_position()
		draw_dashed_line(Vector2(0, 0), mousePosition, Color.DEEP_SKY_BLUE, 15.0, 30.0, true, true)

	
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


func broomSweep():
	var mousePosition = get_global_mouse_position()
	
	# bool to stop double sweeps / unintended behaviour
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


# these two functions receive the signal for the mouse entering / exiting object area
# highlights the object so its more obvious and sets a bool for use elsewhere
func onMouseHover() -> void:
	isMouseHovering = true
	
func onMouseExit() -> void:
	isMouseHovering = false

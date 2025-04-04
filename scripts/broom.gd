extends AnimatableBody2D

var rotationSpeed = 0.025

# variables for sweep tween (sween?) speed & time
var isSweeping = false

var sweepSpeed = 100.0

var maxSweepTime = 0.9
var minSweepTime = 0.75

var maxSweepDistance = 450.0
var minSweepDistance = 60.0

# variable for mouse interactions
var isMouseHovering = false
var isDragging = false

var isMouseInLevel = false

var isRepositioning = false
var lastValidPosition = Vector2()

# variables for keeping the broom within the level bounds
var levelMinimum = Vector2()
var levelMaximum = Vector2()

# feels bad using a hardcoded value here but hey ho
@onready var broomWidth = 12 * $broomSprite.scale.y


func _ready() -> void:
	# just to make sure everything's loaded
	await get_tree().physics_frame
	
	# get the start and end points of bounding rectangle to clamp broom sweeping
	var levelBoundary = $"../levelBoundary/boundaryShape".shape.get_rect().grow(-broomWidth)
	var levelBoundaryPosition = $"../levelBoundary/boundaryShape".global_position
	
	levelMinimum = levelBoundaryPosition + levelBoundary.position
	levelMaximum = levelBoundaryPosition + levelBoundary.end
	
	
func _physics_process(delta: float) -> void:

	# verifies if player is trying to sweep or move the broom
	if isMouseHovering and not isSweeping and not isRepositioning:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			isDragging = true
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			isRepositioning = true
			# stores current (valid) broom position
			lastValidPosition = self.position
		
	# handles the sweeping when player drags from the broom to a valid location
	if isDragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# re-enables physics on broom
		$CollisionShape2D.set_deferred("disabled", false)
		isDragging = false
		
		# dependent on levels each having a level boundary that emits signals here!!
		broomSweep()
		
		# gets rid of dashed line
		queue_redraw()
		
	# draws the dotted blue line and disables physics in pre-sweep
	if isDragging:
		# disables physics on broom when pre-sweep dragging
		$CollisionShape2D.set_deferred("disabled", true)
		# gets the direction of broom -> mouse for rotation setting
		var mousePosition = get_global_mouse_position()
		var directionVector =  mousePosition - self.position
		
		self.rotation = directionVector.angle()
		queue_redraw()
	
	# drops broom after reposition
	if isRepositioning and not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		isRepositioning = false
		
		# if dragged out of bounds
		if not isMouseInLevel:
			self.position = lastValidPosition
		
		# waits for a physics frame before re-enabling physics
		await get_tree().physics_frame
		$CollisionShape2D.set_deferred("disabled", false)
	
	# lets the broom be repositioned with the mouse
	if isRepositioning:
		# disables physics - maybe shouldn't set this constantly!
		$CollisionShape2D.set_deferred("disabled", true)
		
		var mousePosition = get_global_mouse_position()
		self.position = mousePosition
	
	# sets modulation
	if isDragging or isRepositioning:
		$broomSprite.modulate = Color(0.95, 0.95, 0.95, 0.8)
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


## Sweeps the broom. Distance and speed dependent on global variables
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
	var tmpDestination = self.position + (sweepVector.normalized() * tweenDistance)
	
	# clamp distance to level bounding box
	var sweepDestination = tmpDestination.clamp(levelMinimum, levelMaximum)
	
	var tweenSpeed = clampf(sweepSpeed / tweenDistance, minSweepTime, maxSweepTime)
	
	# tween me
	sweepTween.tween_property(self, "global_position", sweepDestination, tweenSpeed)
	
	# callback has to be an icky function (idk how to do anonymous functions)
	sweepTween.tween_callback(sweepTweenCallback)


# these two functions receive signals for the mouse entering / exiting object (broom) area
func onMouseHover() -> void:
	isMouseHovering = true
	
func onMouseExit() -> void:
	isMouseHovering = false

# these two functions receive signals for mouse entering / exiting valid play area
func mouseInLevelBoundary() -> void:
	isMouseInLevel = true

func mouseOutLevelBoundary() -> void:
	isMouseInLevel = false

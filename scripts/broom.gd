extends AnimatableBody2D

# variables for sweep tween (sween?) speed & time
var isSweeping = false

var sweepSpeed = 100.0

var maxSweepTime = 0.9
var minSweepTime = 0.75

var maxSweepDistance = 500.0
var minSweepDistance = 60.0

# variable for mouse interactions
var isMouseHovering = false
var isDragging = false

var isMouseInLevel = false

var isRepositioning = false
var lastValidPosition = Vector2()

# variables for keeping stuff within the level bounds
var levelMinimum = Vector2()
var levelMaximum = Vector2()

var followSpeed = 1.5
var turnSpeed = 2.5

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
		
	# stops dragging if there is no input (duh)
	if isDragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		isDragging = false
		
	# lerps the broom to the mouse constantly to emulate a smooth sweeping motion
	if isDragging:
		var mousePos = get_global_mouse_position()
		mousePos = mousePos.clamp(levelMinimum, levelMaximum)
			
		var directionVector = mousePos - self.position
		var newPos = self.position.lerp(mousePos, delta * followSpeed)	
		var newAngle = lerp_angle(self.rotation, directionVector.angle(), delta * turnSpeed)
	
		self.transform = Transform2D(newAngle, newPos)

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
		
		# who up rotating they broom
		if Input.is_action_just_pressed("MWD"):
			self.rotate(-2 * PI / 30)
		if Input.is_action_just_pressed("MWU"):
			self.rotate(2 * PI / 30)
	
	# sets modulation
	if isRepositioning:
		$broomSprite.modulate = Color(0.95, 0.95, 0.95, 0.8)
	elif isMouseHovering:
		$broomSprite.modulate = Color(1.5, 1.5, 1.5, 1.0)
	else:
		$broomSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
		
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

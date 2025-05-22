extends Node2D

# stupid to do it like this but it saves time and energy. does not scale up well!
var levelBalls = {"lvl0" = 350, "lvl00" = 250, "lvl1" = 1500, "lvl2" = 2000, "lvl3" = 1500, "lvl4" = 1250,
	"lvl5" = 1750}

var ballInstances 

# get the ball
@export var ball : PackedScene
@onready var balls = []

# the camera is centered on the level anyway
@onready var spawnPosition = $Camera.position


func _physics_process(delta: float) -> void:
	pass
	

func _ready() -> void:
	# which level are we on :thinking:
	if levelBalls[self.name]:
		ballInstances = levelBalls[self.name]
	else:
		ballInstances = 1500
	
	await get_tree().physics_frame
	
	# get the level bounding box and spawn the balls inside (with some leeway)
	var levelBoundary = $"levelBoundary/boundaryShape".shape.get_rect().grow(-50)
	var levelBoundaryPosition = $"levelBoundary/boundaryShape".global_position
	
	var levelMinimum = levelBoundaryPosition + levelBoundary.position
	var levelMaximum = levelBoundaryPosition + levelBoundary.end
	
	# we spawn da balls in a rectangle defined by the Vector2
	for i in ballInstances:
			var instance = ball.instantiate()
			
			instance.position = spawnPosition + Vector2(randi_range(levelMinimum.x, levelMaximum.x), 
				randi_range(levelMinimum.y, levelMaximum.y))
				
			balls.append(instance)
			add_child(instance)

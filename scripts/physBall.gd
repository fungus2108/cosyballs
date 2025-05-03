extends RigidBody2D

var hasMoved = false

func _ready():
	$ballSprite.modulate.s = 1
	$ballSprite.modulate.v = 1
	$ballSprite.modulate.h = randf()

func _physics_process(delta: float) -> void:
	pass

func holeColouring(value: float):
	$ballSprite.modulate.v = value

extends RigidBody2D

func _ready():
	$ballSprite.modulate.s = 1
	$ballSprite.modulate.v = 1
	$ballSprite.modulate.h = randf()

func _physics_process(delta: float) -> void:
	pass
		
func _integrate_forces(state):
	if Input.is_action_just_pressed("test"):
		state.apply_impulse(Vector2(randf_range(-800, 800), randf_range(-800, 800)))

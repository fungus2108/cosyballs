extends RigidBody2D

func _ready():
	$ballSprite.modulate.s = 1
	$ballSprite.modulate.v = 1
	$ballSprite.modulate.h = randf()

func _physics_process(delta: float) -> void:
	pass
		
func _integrate_forces(state):
	if Input.is_physical_key_pressed(KEY_F):
		state.apply_impulse(Vector2(randf_range(-300, 300), randf_range(-300, 300)))

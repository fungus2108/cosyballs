extends Node2D

@export var physBall : PackedScene
@onready var balls = []

var timerActive = false

func _ready() -> void:
	DeathRect.fadeIn()

func _physics_process(delta: float) -> void:
	if not timerActive:
		timerActive = true
		await get_tree().create_timer(1.0).timeout

		for i in 500:
			var instance = physBall.instantiate()
	
			instance.position = $spawnMarker.position + Vector2(randf_range(-950, 950), randf_range(-600, 200))
				
			balls.append(instance)
			add_child(instance)

		timerActive = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()

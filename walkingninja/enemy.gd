extends CharacterBody2D

@export var speed: float = 100.0

var direction: int = -1

func _physics_process(delta: float) -> void:
	velocity.x = direction * speed
	move_and_slide()

	# Reverse direction if hitting a wall
	if is_on_wall():
		direction *= -1

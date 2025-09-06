extends CharacterBody2D

@export var speed: int = 200

var direction: int = -1

func _ready() -> void:
	# Add this enemy to the "enemy1" group
	add_to_group("enemy1")

func _physics_process(delta: float) -> void:
	# Move the enemy horizontally
	velocity.x = direction * speed
	move_and_slide()

	# Reverse direction if hitting a wall
	if is_on_wall():
		direction *= -1

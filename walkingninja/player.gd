extends CharacterBody2D
class_name player
const SPEED = 900
const JUMP_VELOCITY = -15000
const ATTACK_COOLDOWN = 0.5  # Cooldown time for attack

@onready var sprite_2d = $Sprite2D
@onready var attack_area = $AttackArea  # The Area2D node for the attack (you'll create this in the scene)
@onready var attack_sprite = $AttackArea/AnimatedSprite2D  # The AnimatedSprite2D for attack animation
@onready var attack = preload("res://attack.tscn")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attack_timer = 0.0  # Track cooldown for attacks


func _physics_process(delta):
	# Handle animations based on movement velocity
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"

	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity.y = gravity * delta
		sprite_2d.animation = "jump"
	
	# Jump logic (when the player presses the jump button)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle movement based on left and right input
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = SPEED * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Attack logic (triggered by pressing a button)
	if Input.is_action_just_pressed("ui_attack") and attack_timer <= 0.0:
		start_attack()
		attack_timer = ATTACK_COOLDOWN  # Reset attack cooldown

	# Update attack cooldown timer
	attack_timer -= delta

	# Check for wall collision
	if is_on_wall():
		game_over()

	# Move the player and update sprite flip direction based on movement
	move_and_slide()
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

# Function to start the attack
func start_attack():
	# Enable the attack area (hitbox)
	attack_area.disabled = false  # Enable the attack hitbox

	# Play the attack animation
	attack_sprite.play("attack")  # Replace "attack" with your actual attack animation name

	# Optionally, set a short delay before the attack area is disabled again
	# (you could use a timer or a duration here)
	await get_tree().create_timer(0.2).timeout  # Wait for 0.2 seconds for the attack duration

	# Disable the attack area after the hitbox duration
	attack_area.disabled = true  # Disable attack area after the hitbox duration

# Game Over function (when player collides with a wall)
func game_over() -> void:
	print("Game Over! Player collided with the enemy.")
	get_tree().paused = true  # Pause the game
	# Optionally, show a "Game Over" screen
	# $GameOverScreen.show()  # Assuming you have a GameOver screen as a UI element
	


func _on_attack_timeout() -> void:
	var attck = attack.instantiate()
	attck.position=position + Vector2(-230,50)
	get_parent().add_child(attck)

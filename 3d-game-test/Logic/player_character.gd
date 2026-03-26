extends CharacterBody3D

# Player movement speed in meters per second
@export var speed : float = 14
# Player downward acceleration in air. In meters per second^2	
@export var fall_acceleration : float = 75

var target_velocity : Vector3 = Vector3.ZERO


func _physics_process(delta:float) -> void:
	# Local variable for storing input direction.
	var direction : Vector3 = Vector3.ZERO
	
	# Check each move input and adjust direction vector.
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Set a basis for the pivot node, set basis to direction.
		$Pivot.basis = Basis.looking_at(direction)
	
	# Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Move the character
	velocity = target_velocity
	move_and_slide()
	
	
	
	
	
	

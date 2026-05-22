extends CharacterBody3D

# Player movement speed in meters per second
@export var speed : float = 14
# Player downward acceleration in air. In meters per second^2	
@export var fall_acceleration : float = 75
# Player upward jump impulse velocity. In meters per second
@export var jump_impulse : float = 20
# Player upward bounce impulse velocity. In meters per second
@export var bounce_impulse : float = 16

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
	
	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Iterate through all collisions that occured this frame
	for index in range(get_slide_collision_count()):
		# We get on of the collisions with the player
		var collision = get_slide_collision(index)
		
		# If there are duplicate collisions with a mob in a single frame
		# the mob will be deleted after the first collision, and a second call to
		# get_collider will return null, leading to a null pointer when calling
		# collision.get_collider().is_in_group("mob").
		# This block of code prevents processing duplicate collisions.
		if collision.get_collider() == null:
			continue
			
		# If collider is mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Check if player hits mob from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, squash mob
				mob.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls
				break
			
	
	# Move the character
	velocity = target_velocity
	move_and_slide()
	
	
	
	
	
	

extends Node3D

@export var mob_scene: PackedScene


func _on_mob_timer_timeout() -> void:
	# Create new instance of mob scene
	var mob = mob_scene.instantiate()
	
	# Choose random location on spawn path
	# Store reference to SpawnLocation node
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# Give it a random offseta
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Spawn the mob by adding to main scene
	add_child(mob)
	

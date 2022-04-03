class_name Player
extends RigidBody2D

signal tile_collided(position, direction)

# Member Variables
export var movement_acceleration = 400.0
export var max_movement_speed = 200.0
export var jump_speed = 150.0
export var max_jump_duration = 0.2
export var jump_grace_duration = 0.1

var is_on_floor = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(_delta):
# 	pass


func _integrate_forces(state):
	applied_force = Vector2.ZERO  # Clear applied forces

	# Handle Movement
	var movement = 0
	if Input.is_action_pressed("player_left"):
		movement -= 1
	if Input.is_action_pressed("player_right"):
		movement += 1

	if movement != 0:
		physics_material_override.friction = 0.1
		if linear_velocity.x < max_movement_speed:
			state.add_central_force(mass * movement_acceleration * movement * Vector2.RIGHT)
	else:
		physics_material_override.friction = 1

	# Handle Collisions
	var was_on_floor = is_on_floor
	is_on_floor = false
	for i in range(state.get_contact_count()):
		var body = state.get_contact_collider_object(i)
		# var contact_velocity = state.get_contact_collider_velocity_at_position(i)
		var pos = state.get_contact_local_position(i)
		var normal = state.get_contact_local_normal(i)

		if body.name == "Dynamic":
			emit_signal('tile_collided', to_global(pos), -normal)

		# Check if player is on floor
		if normal.dot(Vector2.UP) >= cos(PI/4):
			is_on_floor = true

	# Handle Jumping
	if Input.is_action_pressed("player_jump"):
		var grounded = is_on_floor or $GraceTimer.time_left > 0
		var can_jump = grounded or $JumpTimer.time_left > 0
		if can_jump:
			set_axis_velocity(jump_speed * Vector2.UP)
			if $JumpTimer.is_stopped():
				$JumpTimer.start(max_jump_duration)
				$GraceTimer.stop()
	elif was_on_floor and not is_on_floor: # Player fell off ledge
		$GraceTimer.start(jump_grace_duration)
	
	if Input.is_action_just_released("player_jump"):
		$JumpTimer.stop()
		$GraceTimer.stop()


func destroy():
	print("Player Destroyed: Game Over")

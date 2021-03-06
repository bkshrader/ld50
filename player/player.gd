class_name Player
extends RigidBody2D

signal tile_collided(position, direction)
signal game_over

# Member Variables
export var movement_acceleration = 400.0
export var max_movement_speed = 200.0
export var jump_speed = 150.0
export var max_jump_duration = 0.2
export var jump_grace_duration = 0.1

var is_on_floor = false
var is_jump_over = true

var holding: Bomb


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(_delta):
# 	pass

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("player_interact"):
			if holding:
				holding.drop()
				holding = null
			else:
				for body in $GrabArea.get_overlapping_bodies():
					if body is Bomb:
						body.pick_up($CarryPosition)
						holding = body

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
		
		var moving_towards = abs(normal.x + movement) < 0.5
		if body.name == "Dynamic" and was_on_floor and moving_towards:
			emit_signal('tile_collided', to_global(pos), -normal)

		# Check if player is on floor
		if normal.dot(Vector2.UP) >= cos(PI/4):
			is_on_floor = true

	# Handle Jumping
	if Input.is_action_pressed("player_jump"):
		var grounded = is_on_floor or $GraceTimer.time_left > 0
		var can_jump = is_jump_over and grounded or $JumpTimer.time_left > 0
		if can_jump:
			set_axis_velocity(jump_speed * (0.2 if holding else 1.0) * Vector2.UP)
			if $JumpTimer.is_stopped():
				$JumpTimer.start(max_jump_duration)
				$GraceTimer.stop()
	elif was_on_floor and not is_on_floor: # Player fell off ledge
		$GraceTimer.start(jump_grace_duration)
	
	if Input.is_action_just_released("player_jump"):
		is_jump_over = true
		$JumpTimer.stop()
		$GraceTimer.stop()


func destroy():
	set_visible(false)
	max_movement_speed = 0
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal('game_over')


func _on_JumpTimer_timeout():
	is_jump_over = false


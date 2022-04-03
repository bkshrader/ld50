class_name Player
extends RigidBody2D


# Member Variables
export var jump_speed = 200.0
export var movement_speed = 200.0
export var max_jump_duration = 0.3
export var jump_grace_duration = 0.1

var is_on_floor = false


# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(_delta):
# 	pass


func _integrate_forces(state):
	# Check if player is on floor
	var was_on_floor = is_on_floor
	is_on_floor = false
	for i in range(state.get_contact_count()):
		if state.get_contact_local_normal(i).angle_to(Vector2.UP) <= PI/4:
			is_on_floor = true
			break
	
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

	# Handle Movement
	var movement = 0
	if Input.is_action_pressed("player_left"):
		movement -= 1
	if Input.is_action_pressed("player_right"):
		movement += 1

	if movement != 0:
		set_axis_velocity(movement_speed * movement * Vector2.RIGHT)


func destroy():
	print("Player Destroyed: Game Over")


func _on_Player_body_entered(_body):
	pass

func _on_Player_body_exited(body):
	var bodies = get_colliding_bodies()
	bodies.erase(body)

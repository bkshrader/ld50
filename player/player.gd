extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")
var velocity = Vector2.ZERO
var input = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input *= 0
	if Input.is_action_pressed("player_right"):
		input.x += 1
	if Input.is_action_pressed("player_left"):
		input.x -= 1
	if Input.is_action_pressed("player_jump"):
		input.y -= 20
	if Input.is_action_pressed("player_crouch"):
		input.y += 10


func _physics_process(delta):
	self.velocity += GRAVITY * delta
	if not is_on_floor():
		input.y = clamp(input.y, 0, INF)
	self.velocity = move_and_slide(velocity + 10 * input, Vector2.UP, true)


func destroy():
	print("Player Destroyed: Game Over")

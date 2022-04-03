tool
extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var flipped = true


# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Sprite.flip_h = flipped
	$Collision.set_rotation_degrees(90 if flipped else 0)


# Allow bomb to destroy object
func destroy():
	queue_free()

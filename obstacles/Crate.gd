tool
extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var explosive = false
var last_explosive = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if explosive != last_explosive:
		var rect = Rect2(0, 0 if not explosive else 32, 32, 32)
		$Sprite.set_region_rect(rect)
	last_explosive = explosive

# Allows bomb to destroy this object
func destroy():
	if explosive:
		print("boom")
	
	queue_free()

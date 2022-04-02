extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var test_scene = preload("res://levels/test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var test = test_scene.instance()
	add_child(test)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

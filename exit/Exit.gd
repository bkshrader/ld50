extends Node2D

var Player = preload('res://player/player.gd')

signal exit_reached

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_body_entered(body):
	if body is Player:
		print("Exit Reached: End Level")
		emit_signal('exit_reached')
	
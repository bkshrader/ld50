class_name Level
extends Node

const player = preload('res://player/player.tscn')

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawn_player(position: Vector2):
	print("Spawning player at: %s" % position)
	var player_instance = player.instance()
	player_instance.set_name('Player')
	player_instance.set_position(position)
	add_child(player_instance)
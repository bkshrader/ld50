extends Node2D

var player_scene = preload("res://player/player.tscn")

func _ready():
	$Sprite.set_visible(false)
	var player = player_scene.instance()
	add_child(player)

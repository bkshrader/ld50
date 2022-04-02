extends Node2D

func _ready():
	self.set_visible(false)
	var current_scene = get_tree().get_current_scene()
	if current_scene is Level:
		current_scene.call_deferred('spawn_player', position)

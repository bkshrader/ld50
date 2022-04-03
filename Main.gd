extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# var test_scene = preload("res://levels/test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_menu = get_child(0)
	main_menu.connect('load_scene', self, 'on_load_scene')
	# var test = test_scene.instance()
	# test.set_name("Level")
	# add_child(test)


func remove_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()


func on_load_scene(scene):
	var scene_class = load(scene)
	var scene_instance = scene_class.instance()
	remove_children()
	add_child(scene_instance)
	if scene_instance.has_signal('load_scene'):
		scene_instance.connect('load_scene', self, 'on_load_scene')

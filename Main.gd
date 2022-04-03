extends Node2D


# Declare member variables here. Examples:
var history = ["res://ui/MainMenu.tscn"]

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
	history.push_front(scene)
	var scene_class = load(scene)
	var scene_instance = scene_class.instance()
	remove_children()
	add_child(scene_instance)
	
	if scene_instance.has_signal('load_scene'):
		scene_instance.connect('load_scene', self, 'on_load_scene')
	
	if scene_instance.has_signal('reload_scene'):
		scene_instance.connect('reload_scene', self, 'on_reload_scene')


func on_reload_scene():
	on_load_scene(history[0])
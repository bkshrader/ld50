extends Node2D


# Declare member variables here. Examples:
var history = ["res://ui/MainMenu.tscn"]

var regex = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_menu = get_child(0)
	main_menu.connect('load_scene', self, 'on_load_scene')
	
	regex.compile("(\\d+)\\.tscn$")


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
	
	if scene_instance.has_signal('previous_scene'):
		scene_instance.connect('previous_scene', self, 'on_previous_scene')
		
	if scene_instance.has_signal('next_scene'):
		scene_instance.connect('next_scene', self, 'on_next_scene')
	
	if scene_instance.has_signal('load_main'):
		scene_instance.connect('load_main', self, 'on_load_main')


func on_reload_scene():
	on_load_scene(history.pop_front())


func on_previous_scene():
	history.pop_front()
	on_load_scene(history[0])


func on_next_scene():
	var result = regex.search(history[0])
	if result:
		var next_index = int(result.get_string(1)) + 1
		if next_index < 10:
			var next_scene = 'res://levels/Level%d.tscn' % next_index
			on_load_scene(next_scene)
		else:
			on_load_main()


func on_load_main():
	on_load_scene(history.back())

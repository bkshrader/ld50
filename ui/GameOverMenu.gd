extends CanvasLayer


signal previous_scene
signal load_scene(scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Retry_pressed():
	emit_signal('previous_scene')




func _on_LevelSelect_pressed():
	emit_signal('load_scene', 'res://ui/LevelMenu.tscn')


func _on_Quit_pressed():
	get_tree().quit()

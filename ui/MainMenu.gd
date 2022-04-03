extends Node

signal load_scene(scene)

func _on_NewGame_pressed():
	emit_signal('load_scene', 'res://levels/test.tscn')

func _on_Levels_pressed():
	emit_signal('load_scene', 'res://ui/LevelMenu.tscn')

func _on_Credits_pressed():
	pass # Replace with function body.
	
func _on_Exit_pressed():
	get_tree().quit()


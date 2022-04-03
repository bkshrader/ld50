extends Node

signal load_scene(scene)

func _on_Button_pressed():
	emit_signal('load_scene', 'res://ui/MainMenu.tscn')

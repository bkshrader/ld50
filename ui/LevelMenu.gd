extends Node

signal load_scene(scene)
signal previous_scene

func _on_Button_pressed():
	emit_signal('previous_scene')

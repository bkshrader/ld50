extends Node

signal load_scene(scene)
signal previous_scene


func _on_level_selected(level):
	emit_signal('load_scene', 'res://levels/Level%d.tscn' % level)


func _on_back_button_pressed():
	emit_signal('previous_scene')

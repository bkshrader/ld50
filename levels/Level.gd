class_name Level
extends Node

const player = preload('res://player/player.tscn')

signal reload_scene

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action("ui_reset"):
			emit_signal('reload_scene')

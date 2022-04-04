extends Node


signal load_scene(scene)

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel") and not $CreditsDialog.visible:
			_on_Exit_pressed()


func _on_NewGame_pressed():
	emit_signal('load_scene', 'res://levels/Level1.tscn')


func _on_Levels_pressed():
	emit_signal('load_scene', 'res://ui/LevelMenu.tscn')


func _on_Credits_pressed():
	$CreditsDialog.popup_centered_minsize(Vector2(500, 450))


func _on_Exit_pressed():
	get_tree().quit()


func _on_Close_pressed():
	var e = InputEventAction.new()
	e.action = "ui_cancel"
	e.pressed = true
	Input.parse_input_event(e)

tool
extends Node2D

signal activated
signal deactivated


export var pressed = false setget set_pressed, is_pressed
export var press_duration = 0.4


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_pressed(press):
	$Tween.remove_all()
	if press and not pressed:
		# Tween press down
		$Tween.interpolate_property($Button, 'position', $ButtonUp.position, $ButtonDown.position,
		press_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		emit_signal("activated")
	if not press and pressed:
		$Tween.interpolate_property($Button, 'position', $ButtonDown.position, $ButtonUp.position,
		press_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		emit_signal("deactivated")
	
	$Tween.start()
	
	pressed = press

func is_pressed():
	return pressed


func _on_Area2D_body_entered(_body):
	if not Engine.editor_hint:
		set_pressed(true)


func _on_Area2D_body_exited(_body):
	$ReleaseDelay.start()


func _on_ReleaseDelay_timeout():
	if not $Collision.get_overlapping_bodies():
		set_pressed(false)

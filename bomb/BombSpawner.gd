extends Node

const bomb = preload('res://bomb/Bomb.tscn')

# Member variables
export var enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if enabled and get_child_count() == 0:
		add_child(bomb.instance())

extends Node

const bomb = preload('res://bomb/Bomb.tscn')

# Member variables
export var enabled = true
export var spawn_delay = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_bomb()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if enabled and get_child_count() == 1:
		if $SpawnDelay.is_stopped():
			$SpawnDelay.start()

func spawn_bomb():
	add_child(bomb.instance())

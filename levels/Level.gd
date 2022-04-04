class_name Level
extends Node

signal reload_scene
signal load_scene(scene)


var dynamic_layer: TileMap
var static_layer: TileMap


func _ready():
	dynamic_layer = get_node('Dynamic')
	static_layer  = get_node('Static')

	var player = find_node('Player', true, false)
	if player:
		player.connect('tile_collided', self, 'on_collision')
		player.connect('game_over', self, 'on_game_over')


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action("ui_reset"):
			emit_signal('reload_scene')


func sort_y_desc(a, b):
	return a.y > b.y


func is_tile_empty(pos: Vector2):
	return dynamic_layer.get_cellv(pos) == TileMap.INVALID_CELL and static_layer.get_cellv(pos) == TileMap.INVALID_CELL

func can_tile_slide(pos: Vector2, dir: Vector2):
	var is_frictionless = dynamic_layer.get_cellv(pos + Vector2.UP) == TileMap.INVALID_CELL or dir.is_equal_approx(Vector2.DOWN)
	return is_tile_empty(pos + dir) and is_frictionless

func try_move_tile(pos, dir):
	if can_tile_slide(pos, dir):
		var tile = dynamic_layer.get_cellv(pos)
		dynamic_layer.set_cellv(pos + dir, tile)
		dynamic_layer.set_cellv(pos, -1)

func _physics_process(_delta):
	if dynamic_layer is TileMap:
		var dynamic_tiles = dynamic_layer.get_used_cells()
		dynamic_tiles.sort_custom(self, 'sort_y_desc')
		
		for pos in dynamic_tiles:
			# Apply "gravity" to dynamic tiles
			try_move_tile(pos, Vector2.DOWN)

func on_collision(position, direction):
	var pos = dynamic_layer.world_to_map(position + 16 * direction) / 2

	try_move_tile(pos, direction)

func on_game_over():
	emit_signal('load_scene', 'res://ui/GameOverMenu.tscn')


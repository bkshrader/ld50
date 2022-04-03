class_name Level
extends Node

signal reload_scene


var dynamic_layer: TileMap
var static_layer: TileMap


func _ready():
	dynamic_layer = get_node('Dynamic')
	static_layer  = get_node('Static')

	var player = find_node('Player', true, false)
	if player:
		player.connect('tile_collided', self, 'on_collision')


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.is_action("ui_reset"):
			emit_signal('reload_scene')


func sort_y_desc(a, b):
	return a.y > b.y


func is_tile_empty(pos: Vector2):
	return dynamic_layer.get_cellv(pos) == TileMap.INVALID_CELL and static_layer.get_cellv(pos) == TileMap.INVALID_CELL


func try_move_tile(pos, new_pos):
	if is_tile_empty(new_pos):
		var tile = dynamic_layer.get_cellv(pos)
		dynamic_layer.set_cellv(new_pos, tile)
		dynamic_layer.set_cellv(pos, -1)

func _physics_process(_delta):
	if dynamic_layer is TileMap:
		var dynamic_tiles = dynamic_layer.get_used_cells()
		dynamic_tiles.sort_custom(self, 'sort_y_desc')
		
		for pos in dynamic_tiles:
			# Apply "gravity" to dynamic tiles
			var down = pos + Vector2.DOWN
			try_move_tile(pos, down)

func on_collision(position, direction):
	var pos = dynamic_layer.world_to_map(position + 16 * direction) / 2
	var new_pos = pos + direction

	try_move_tile(pos, new_pos)


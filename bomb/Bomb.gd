extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var fuse_duration = 10
export var beep_interval_min = 0.05
export var beep_interval_max = 1
export var blast_area_gradient: Gradient
export var blast_area_fade_duration = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(fuse_duration)
	$Beeper.start(beep_interval_max)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TimerLabel.set_text("%02d" % ceil($Timer.time_left))
	if $BlastFade.time_left > 0:
		update()


func _draw():
	var color = blast_area_gradient.interpolate($BlastFade.time_left / $BlastFade.wait_time)
	draw_circle(Vector2.ZERO, $BlastArea/CollisionShape2D.shape.radius, color)


func find_colliding_tiles(tilemap: TileMap):
	var result = []
	var tile_rect = RectangleShape2D.new()
	tile_rect.set_extents(tilemap.cell_size)
	for pos in tilemap.get_used_cells():
		var tile_transform = Transform2D(0, tilemap.map_to_world(pos))
		var blast_area_transform = self.global_transform
		if $BlastArea/CollisionShape2D.shape.collide(blast_area_transform, tile_rect, tile_transform):
			result.append(pos)
	return result


func _on_Fuse_timeout():
	set_sleeping(true)
	$Beeper.stop()
	$Sprite.set_visible(false)
	$TimerLabel.set_visible(false)
	$ExplosionSFX.play()
	$ExplosionFX.set_emitting(true)
	$BlastFade.start(blast_area_fade_duration)
	var bodies = $BlastArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Dynamic":
			var tiles = find_colliding_tiles(body)
			for pos in tiles:
				body.set_cellv(pos, -1)
		if body.has_method("destroy"):
			body.destroy()


func _on_Beep():
	$TimerSFX.play()
	$Beeper.set_wait_time(lerp(beep_interval_min, beep_interval_max, $Timer.time_left / $Timer.wait_time))


func _on_Bomb_body_entered(body):
	if body.name == "Player" and $Timer.time_left < fuse_duration - 1:
		$TimerResetSFX.play()
		$Timer.start(fuse_duration)

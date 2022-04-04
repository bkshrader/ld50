class_name Bomb
extends RigidBody2D


export var fuse_duration = 10
export var beep_interval_min = 0.05
export var beep_interval_max = 1
export var blast_area_gradient: Gradient
export var blast_area_fade_duration = 1.0

var attached_to: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_timer(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$TimerLabel.set_text("%02d" % ceil($Timer.time_left))
	if $BlastFade.time_left > 0:
		update()


func _draw():
	var color = blast_area_gradient.interpolate($BlastFade.time_left / $BlastFade.wait_time)
	draw_circle(Vector2.ZERO, $BlastArea/CollisionShape2D.shape.radius, color)


func _integrate_forces(state):
	if attached_to:
		state.set_transform(attached_to.global_transform) 


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


func reset_timer(play_sound:bool = true):
	$Timer.start(fuse_duration)
	$Beeper.start(beep_interval_max)
	if play_sound:
		$TimerResetSFX.play()


func pause_timer():
	$Timer.paused = true
	$Beeper.paused = true


func unpause_timer():
	$Timer.paused = false
	$Beeper.paused = false


func pick_up(attach_to: Node2D):
#	reset_timer()
	pause_timer()
	set_deferred("custom_integrator", true)
	$CollisionShape2D.set_deferred("disabled", true)
	attached_to = attach_to


func drop():
	unpause_timer()
	set_deferred("custom_integrator", false)
	$CollisionShape2D.set_deferred("disabled", false)
	attached_to = null


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
	$Beeper.start(lerp(beep_interval_min, beep_interval_max, $Timer.time_left / $Timer.wait_time))


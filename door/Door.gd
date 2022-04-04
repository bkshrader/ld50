tool
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var opened = false setget set_opened, is_opened
export var inverted = false
export var open_duration = 0.5
export var trigger: NodePath

const REGION_OPENED = Rect2(0, 128, 32, 0)
const REGION_CLOSED = Rect2(0, 128, 32, 32)


# Called when the node enters the scene tree for the first time.
func _ready():
	var trigger_node = get_node(trigger)
	if trigger_node:
		if trigger_node.has_signal('activated'):
			trigger_node.connect('activated', self, 'open')
		if trigger_node.has_signal('deactivated'):
			trigger_node.connect('deactivated', self, 'close')



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_opened(open):
	var should_open = open if not inverted else not open
	
	$Tween.remove_all()
	if should_open and not opened:
		# Tween door opening
		$Tween.interpolate_property($Top, "region_rect", REGION_CLOSED, REGION_OPENED,
		 open_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.interpolate_property($Bottom, "region_rect", REGION_CLOSED, REGION_OPENED,
		 open_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	elif not should_open and opened:
		# Tween door closing
		$Tween.interpolate_property($Top, "region_rect", REGION_OPENED, REGION_CLOSED,
		 open_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Tween.interpolate_property($Bottom, "region_rect", REGION_OPENED, REGION_CLOSED,
		 open_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
		
	$Tween.interpolate_callback($Collider/CollisionShape2D, open_duration, 'set_deferred', 'disabled', should_open)
	$Tween.start()
	
	opened = should_open


func is_opened():
	return opened


func open():
	set_opened(true)


func close():
	set_opened(false)

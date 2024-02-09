extends Node2D

@export var enable_cursor_pan: bool = true
@export var is_locked: bool = false

var camera_size: Vector2 = get_viewport_rect().size

func _ready():
	pass
	
func _process(delta: float):
	camera_size = get_viewport_rect().size / $Camera2D.zoom
	if Input.is_action_just_pressed("toggle_camera_lock"):
		is_locked = !is_locked

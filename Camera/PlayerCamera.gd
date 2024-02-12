extends Node2D

## Enable/disable camera pan with the mouse cursor.
## Can be useful when running multiple instances of the game.
## Rr some players may just prefer it disabled.
@export var enable_cursor_pan: bool = true
## Can also be toggled with the z key
@export var is_locked: bool = false

var camera_size: Vector2

func _ready():
	camera_size = get_viewport_rect().size
	
func _process(delta: float):
	camera_size = get_viewport_rect().size / $Camera2D.zoom

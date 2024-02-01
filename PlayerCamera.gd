extends Camera2D

@export var camera_pan_speed: int = 400
@export var camera_zoom: float = 0.1
@export var camera_zoom_min: float = 0.3
@export var camera_zoom_max: float = 2.5
# multiplier for the speed the camera moves at when panning with the middle mouse button
@export var camera_mmb_pan_multiplier: float = 0.02
@onready var camera_zoom_delta = Vector2(camera_zoom, camera_zoom)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var mmb_initial_pos: Vector2 = Vector2.ZERO
var mmb_pressed_initial_camera_pos: Vector2 = Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var velocity: Vector2 = Vector2.ZERO
	# pan camera with arrow keys
	if Input.is_action_pressed("camera_pan_left"):
		velocity.x -= 1
	if Input.is_action_pressed("camera_pan_down"):
		velocity.y += 1
	if Input.is_action_pressed("camera_pan_right"):
		velocity.x += 1
	if Input.is_action_pressed("camera_pan_up"):
		velocity.y -= 1
		
	# camera zoom
	if Input.is_action_just_released("camera_zoom_in"):
		zoom += camera_zoom_delta
		if zoom.x > camera_zoom_max:
			zoom = Vector2(camera_zoom_max, camera_zoom_max)
	if Input.is_action_just_released("camera_zoom_out"):
		zoom -= camera_zoom_delta
		if zoom.x < camera_zoom_min:
			zoom = Vector2(camera_zoom_min, camera_zoom_min)

	# mmb camera pan
	if Input.is_action_just_pressed("camera_pan_mmb"):
		mmb_initial_pos = get_global_mouse_position()
		mmb_pressed_initial_camera_pos = position
	if Input.is_action_pressed("camera_pan_mmb"):
		var mmb_distance: Vector2 = get_global_mouse_position() - mmb_initial_pos
		velocity += -camera_mmb_pan_multiplier * mmb_distance
	
		
	# pan camera if mouse at camera bounds
	var mouse_position: Vector2 = get_global_mouse_position()
	var camera_center: Vector2 = get_screen_center_position()
	# if cursor's distance from center is > 0.9 * distance from center to bounds
	# pan the camera in that direction
	if velocity.length() > 0:
		position += velocity * camera_pan_speed * delta

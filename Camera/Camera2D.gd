extends Camera2D

##### constants #####
const CAMERA_PAN_SPEED: int = 400
# how much the increment/decrement the camera zoom with each 'press' of the scroll wheel
const CAMERA_ZOOM_DELTA: Vector2 = Vector2(0.1, 0.1)
const CAMERA_ZOOM_MIN: float = 0.4
const CAMERA_ZOOM_MAX: float = 4.0

# multiplier for the speed the camera moves at when panning with the middle mouse button
# change as needed
const CAMERA_MMB_PAN_MULTIPLIER: float = 0.05
# speed at which the camera should move when being panned by the cursor
const CURSOR_PAN_SPEED: int = 1

var zoom_scaling: float = 1.0

func _ready():
	change_volume(zoom.x)
	pass
	
func handle_cursor_pan():
	# mouse cursor pan logic
	var velocity: Vector2 = Vector2.ZERO
	var mouse_pos: Vector2 = get_global_mouse_position()
	var camera_center = global_position
	var camera_size: Vector2 = get_parent().camera_size
	var mouse_dist_from_center: Vector2 = mouse_pos - camera_center
	var pan_activation_threshold: Vector2 = 0.45 * camera_size
	# x and y components of zoom vector are always equal
	if mouse_dist_from_center.x > pan_activation_threshold.x:
		velocity.x += CURSOR_PAN_SPEED
	elif mouse_dist_from_center.x < -pan_activation_threshold.x:
		velocity.x -= CURSOR_PAN_SPEED
		
	if mouse_dist_from_center.y > pan_activation_threshold.y:
		velocity.y += CURSOR_PAN_SPEED
	elif mouse_dist_from_center.y < -pan_activation_threshold.y:
		velocity.y -= CURSOR_PAN_SPEED
	return velocity

var mmb_initial_pos: Vector2 = Vector2.ZERO
var mmb_pressed_initial_camera_pos: Vector2 = Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if get_parent().is_locked:
		return
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
		zoom_in()
	if Input.is_action_just_released("camera_zoom_out"):
		zoom_out()
	get_parent().camera_size = get_viewport_rect().size / zoom
	zoom_scaling = 1.0 / zoom.x
	# mmb camera pan
	if Input.is_action_just_pressed("camera_pan_mmb"):
		mmb_initial_pos = get_global_mouse_position()
		mmb_pressed_initial_camera_pos = position
	elif Input.is_action_pressed("camera_pan_mmb"):
		var mmb_distance: Vector2 = get_global_mouse_position() - mmb_initial_pos
		velocity += -CAMERA_MMB_PAN_MULTIPLIER * mmb_distance
		# assume player isn't trying to pan with the cursor if they are already trying to pan with mmb
	elif get_parent().enable_cursor_pan:
		velocity += handle_cursor_pan()
			
	if velocity.length() > 0:
		position += velocity * CAMERA_PAN_SPEED * zoom_scaling * delta

func zoom_in():
		zoom += CAMERA_ZOOM_DELTA
		if zoom.x > CAMERA_ZOOM_MAX:
			zoom = Vector2(CAMERA_ZOOM_MAX, CAMERA_ZOOM_MAX)
		change_volume(zoom.x)
func zoom_out():
		zoom -= CAMERA_ZOOM_DELTA
		if zoom.x < CAMERA_ZOOM_MIN:
			zoom = Vector2(CAMERA_ZOOM_MIN, CAMERA_ZOOM_MIN)
		change_volume(zoom.x)
func _input(event):
	if event is InputEventPanGesture:
		if event.delta.y < 0.0:
			zoom_in()
		elif event.delta.y > 0.0:
			zoom_out()
			
func change_volume(zoom_amount:float):
	const max_db = 0.0
	const min_db = -60.0
	
	var	volume = (min_db + ((zoom_amount - CAMERA_ZOOM_MIN) / (CAMERA_ZOOM_MAX - CAMERA_ZOOM_MIN)) * (max_db - min_db))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),volume)
	
		


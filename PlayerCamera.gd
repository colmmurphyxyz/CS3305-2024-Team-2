extends Camera2D

@export var camera_pan_speed: int = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("camera_pan_left"):
		velocity.x -= 1
	if Input.is_action_pressed("camera_pan_down"):
		velocity.y += 1
	if Input.is_action_pressed("camera_pan_right"):
		velocity.x += 1
	if Input.is_action_pressed("camera_pan_up"):
		velocity.y -= 1
		
	position += velocity * camera_pan_speed * delta

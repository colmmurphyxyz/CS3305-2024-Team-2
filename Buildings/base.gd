extends StaticBody2D


@export var sprite_texture:Texture2D
var is_following_mouse = true

func _ready():
	#add Sprite2D
	var sprite:Sprite2D = Sprite2D.new()
	add_child(sprite)
	sprite.texture = sprite_texture
	sprite.scale=Vector2(.3,.3)
	#add collision box
	var collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	#set shape of collision
	
func _process(delta):
	if is_following_mouse:
		# Move the object with the mouse
		global_position = get_global_mouse_position()

func start_following_mouse():
	# Enable following the mouse
	is_following_mouse = true

func stop_following_mouse():
	# Disable following the mouse

	# Check for collisions with other objects at the final position
	var final_collision = move_and_collide(Vector2.ZERO)

	if final_collision != null:
		# Handle collision in the final position (e.g., change color, provide feedback)
		print("Collision detected at the final position!")
		return false
		# You may want to undo the movement or take appropriate action
	else:
		# No collision, perform any additional logic
		print("No collision at the final position!")
		is_following_mouse = false
		return true

func select():
	start_following_mouse()

func deselect():
	stop_following_mouse()

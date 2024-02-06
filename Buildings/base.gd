extends StaticBody2D

@export var sprite_texture:Texture2D
var is_following_mouse = true
var border: Line2D
var final_collision = move_and_collide(Vector2.ZERO, true)

func _ready():
	# add Sprite2D
	var sprite: Sprite2D = Sprite2D.new()
	add_child(sprite)
	sprite.texture = sprite_texture
	sprite.scale = Vector2(0.3, 0.3)

	# add collision box
	var collision_shape = CollisionShape2D.new()
	add_child(collision_shape)

	# set shape of collision
	var sprite_half_extents = sprite.texture.get_size() * sprite.scale / 2.00
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.extents = sprite_half_extents
	collision_shape.shape = rectangle_shape
	collision_layer = 0 # disable collisions with units
	collision_mask = 1 + 2
	
	# add boarder lines
	border = Line2D.new()
	add_child(border)
	
	# set collision box as perimeter
	border.points = [
		Vector2(-sprite_half_extents.x, -sprite_half_extents.y),
		Vector2(sprite_half_extents.x, -sprite_half_extents.y),
		Vector2(sprite_half_extents.x, sprite_half_extents.y),
		Vector2(-sprite_half_extents.x, sprite_half_extents.y),
		Vector2(-sprite_half_extents.x, -sprite_half_extents.y),
	]

	border.default_color = Color(1, 1, 1)  # Set the border color to red
	border.width = 2  # Adjust the width of the border
	
func _process(delta):
	if is_following_mouse:
		# follow mouse movement
		global_position = get_global_mouse_position()
		final_collision = move_and_collide(Vector2.ZERO, true, 0.08, true)
		if final_collision != null:
			border.default_color = Color(1,0,0)
		else:
			border.default_color = Color(0,1,0)

func start_following_mouse():
	# enable placement
	is_following_mouse = true

func stop_following_mouse():
	# place down
	# check for collisions with other objects at the final position
	final_collision = move_and_collide(Vector2.ZERO, true, 0.08, true)
	if final_collision != null:
		print("Collision detected at the final position!")
		# add end-user feedback
		return false

	else:
		print("No collision at the final position!")
		border.visible = false
		# add end-user feedback
		is_following_mouse = false
		collision_layer = 2# re-enable collisions to prevent stacking
		return true 

func select():
	start_following_mouse()

func deselect():
	stop_following_mouse()

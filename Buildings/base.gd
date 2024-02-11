extends StaticBody2D

@export var sprite_texture:Texture2D
@export var is_following_mouse = true
@onready var border: Line2D
var final_collision = move_and_collide(Vector2.ZERO, true)
var team:String = "1"
var is_active = false

#const ACTION_INTERVAL = 1.0
#var time_accumulator: float = 0.0

var is_broken = true
var in_area: Array = []

func _ready():
	add_to_group("Buildings")
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
	
	var detection_area = Area2D.new()
	add_child(detection_area)
	
	var collision_circle = CollisionShape2D.new()
	collision_circle.shape = CircleShape2D.new()
	collision_circle.shape.radius = sprite_half_extents.length() * 1.2
	
	detection_area.add_child(collision_circle)
	
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

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
	border.default_color = Color(1, 1, 1)  # Set the border color to white
	border.width = 2  # Adjust the width of the border
	
func _process(delta):
	if is_following_mouse:
		# follow mouse movement
		global_position = get_global_mouse_position()
		final_collision = move_and_collide(Vector2.ZERO, true, 0.08, true)
		if final_collision != null:
			border.default_color = Color(1,0,0)
			change_border_colour(Color(1,0,0))
		else:
			border.default_color = Color(0,1,0)
			change_border_colour(Color(0,1,0))
		

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
		#collision_layer = 2# re-enable collisions to prevent stacking
		return true 


# This is for selection system, not for building placement, please use other function names and see 
# select/deselect usage in unit - Ben
func select():
	start_following_mouse()

func deselect():
	stop_following_mouse()

func change_border_colour(color):
	border.default_color = color
	
func _on_detection_area_body_entered(object):
	var parent = object.get_parent()
	if parent.get_team() == "1":
		in_area.append(object)

# Signal handler for body exited
func _on_detection_area_body_exited(object):
	in_area.erase(object)

extends StaticBody2D
class_name Base

@export var sprite_texture:Texture2D
@export var is_following_mouse = true
@onready var border: Line2D
var final_collision = move_and_collide(Vector2.ZERO, true)
@export var team: String = "1"
var is_active = false
var sprite:Sprite2D
#const ACTION_INTERVAL = 1.0
#var time_accumulator: float = 0.0
@onready var detection_area = Area2D.new()
@onready var collision_circle = CollisionShape2D.new()

var is_broken = true
var in_area: Array = []
var enemy_in_area: Array = []

@onready var healthbar = $Healthbar
@export var explosion:PackedScene
var close_mining_units:Array = []

var max_hp = 100.0
var health = 1.0

var barrack_placed = false
var laboratory_placed = false
var fusion_lab_placed = false


func _ready():
	add_to_group("Buildings")
	# add Sprite2D
	sprite= Sprite2D.new()
	add_child(sprite)
	sprite.texture = sprite_texture
	sprite.scale = Vector2(2, 2)
	# add collision box
	var collision_shape = CollisionShape2D.new()
	add_child(collision_shape)

	# set shape of collision
	var sprite_half_extents = sprite.texture.get_size() * sprite.scale / 4.00
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.extents = sprite_half_extents
	collision_shape.shape = rectangle_shape
	
	add_child(detection_area)
	
	collision_circle.shape = CircleShape2D.new()
	collision_circle.shape.radius = sprite_half_extents.length() * 2
	
	detection_area.add_child(collision_circle)
	
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
	border.width = 1  # Adjust the width of the border

	healthbar.max_value = round(max_hp)
	add_to_group("Constructions")
	
func _process(_delta: float):
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
	else:
		healthbar.value=health
		if health <= 0:
			queue_free()
		if health < max_hp:
			sprite.modulate=Color.DIM_GRAY
			if in_area.size() > 0:
				for body in in_area:
					var unit:Unit = body.get_parent()
					if unit.state_name=="building":
						health += 0.1
						print("Repairing...", round(health), "/", max_hp)
				if health >= max_hp:
					is_active = true
					sprite.modulate=Color(1,1,1)
					remove_from_group("Constructions")
					#add_to_group("Mines")
					#print("Repair complete!")
		else:
			#print("Repair stopped")
			pass

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
		collision_layer = 2 + 13# re-enable collisions to prevent stacking
		#collision_layer = 2# re-enable collisions to prevent stacking
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)
		return true 

func get_team():
	return team

func set_collision_circle_radius(radius: float):
	collision_circle.shape.radius = radius
# This is for selection system, not for building placement, please use other function names and see 
# select/deselect usage in unit - Ben
func select():
	start_following_mouse()

func deselect():
	stop_following_mouse()

func change_border_colour(color):
	border.default_color = color
	
func damage(damage_amount):
	#sprite2d.material.set("shader_param/active",true)
	health-=damage_amount
	healthbar.value=health
	
	if health <= 0:
		var explosion_node = explosion.instantiate()
		get_parent().add_child(explosion_node)
		explosion_node.global_position = global_position
		@warning_ignore("integer_division")
		explosion_node.scale *= (sprite.texture.get_width() / 400)
		queue_free()
	
func _on_detection_area_body_entered(object):
	var parent = object.get_parent()
	if object in get_tree().get_nodes_in_group("Buildings"):
		parent=object
	if parent.get_team() == team:
		in_area.append(object)
	else:
		enemy_in_area.append(object)

# Signal handler for body exited
func _on_detection_area_body_exited(object):
	var parent = object.get_parent()
	if parent.get_team() == team:
		in_area.erase(object)
	else:
		enemy_in_area.erase(object)
	
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)
	
func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
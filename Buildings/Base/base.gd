extends StaticBody2D
class_name Base

signal building_destroyed

# export variables
@export var team: String = "1"
@export var sprite_texture:Texture2D
@export var max_hp = 250.0
@export var health = 1.0
@export var is_following_mouse = true
## what exactly does 'being active' refer to?
@export var is_active: bool = false
@export var is_placed: bool = false
var visibility_number = 0
var is_building = true
# public variables
var explosion_scene: PackedScene = \
		preload("res://Unit/BaseUnit/Explosion.tscn") as PackedScene
var final_collision = move_and_collide(Vector2.ZERO, true)
var is_broken = true
# ally/enemy references are to the CharacterBody of a unit and the StaticBody of buildings
var allies_in_area: Array = []
var enemies_in_area: Array = []
var close_mining_units: Array = []
var light:PointLight2D

#var barrack_placed: bool = false
#var laboratory_placed: bool = false
#var fusion_lab_placed: bool = false

# onready variables
@onready var border: Line2D = $Border
@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var collision_circle: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var healthbar: TextureProgressBar = $Healthbar
var building_sfx:AudioStreamPlayer2D
# failsafe for other object detection
var overlapping: Array = []

func _ready():
	add_to_group("Buildings")
	var collision_shape: CollisionShape2D = $BuildingCollisionShape
	if team !=GameManager.team:
		$Sprite2D.material.set("shader_parameter/team2",true)
	# set shape of collision
	var sprite_half_extents = sprite.texture.get_size() * sprite.scale / 4.00
	var rectangle_shape = RectangleShape2D.new()
	light = PointLight2D.new()
	add_child(light)
	light.scale=Vector2(2,2)
	light.texture=load("res://Assets/pointLightTexture.webp")
	light.blend_mode=Light2D.BLEND_MODE_MIX
	if GameManager.team != team:
		light.visible==false
		visible=false
			
# Disable collisons before placement 
	collision_layer = 0
	collision_mask = 1 + 2

	border.visible = false
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

	# Add healthbar and add to repairable class
	healthbar.max_value = round(max_hp)
	add_to_group("Constructions")
	z_index = 10 # Move on top layer, fix for ore deposit sprite layering
	
	# playspawn SFX on building place
	if is_placed and team == GameManager.team:
		print("playing spawn sound, id=", multiplayer.get_unique_id())
		$SpawnSound.play()
	else:
		print("not playing spawn sound, I am ", GameManager.team)
	
func _process(delta: float):

	#visible = is_placed or GameManager.team == team

	if !is_multiplayer_authority():
		return
	if visibility_number< 1 and GameManager.team != team:
		visible=false
	if is_following_mouse:
		global_position = get_global_mouse_position()
		final_collision = move_and_collide(Vector2.ZERO, true, 0.08, true)
		# Test for placeable areas
		if final_collision != null:
			border.default_color = Color(1,0,0)
			change_border_colour(Color(1,0,0))
		else:
			border.default_color = Color(0,1,0)
			change_border_colour(Color(0,1,0))
	else:
		healthbar.value = health
		if health <= 0:
			queue_free_on_server.rpc_id(1)
		if health < max_hp:
			sprite.modulate=Color.DIM_GRAY
			if allies_in_area.size() > 0:
				for body in allies_in_area:
					if !is_instance_valid(body): continue
					if body.is_building==false and body.get_parent().state_name=="building": # if body is not a bulding
						health += 10 * delta
				if health >= max_hp:
					is_active = true
					sprite.modulate=Color(1,1,1)
					remove_from_group("Constructions")
					#add_to_group("Mines")
					#print("Repair complete!")
		else:
			#print("Repair stopped")
			pass
			
		# Failsafe for detection radius as its inactive before placement 
		overlapping = detection_area.get_overlapping_bodies()
		for object in overlapping:
			var parent = object.get_parent()
			if object in get_tree().get_nodes_in_group("Buildings"):
				parent=object
			if is_instance_valid(parent) and parent.get_team() == team:
				if not object in allies_in_area:
					allies_in_area.append(object)
			else:
				if not object in enemies_in_area:
					enemies_in_area.append(object)

func start_following_mouse():
	is_following_mouse = true

func stop_following_mouse():
	# place down
	# check for collisions with other objects at the final position
	final_collision = move_and_collide(Vector2.ZERO, true, 0.08, true)
	if final_collision != null:
		#print("Collision detected at the final position!")
		return false

	else:
		#print("No collision at the final position!")
		border.visible = false
		is_following_mouse = false
		collision_layer = 2 + 13 # re-enable collisions to prevent stacking
		#detection_area.body_entered.connect(_on_detection_area_body_entered)
		#detection_area.body_exited.connect(_on_detection_area_body_exited)
		return true 

func get_team():
	return team

func set_collision_circle_radius(radius: float):
	collision_circle.shape.radius = radius
# This is for selection system, not for building placement, please use other function names and see 
# select/deselect usage in unit - Ben

# Select and deselect needed on all nodes for netting to work
func select():
	start_following_mouse()

func deselect():
	stop_following_mouse()

func change_border_colour(color):
	border.default_color = color
	
@rpc("any_peer", "call_local", "reliable")
func damage(damage_amount):
	#sprite2d.material.set("shader_param/active",true)
	health -= damage_amount
	healthbar.value = health
	
	if health <= 0:
		building_destroyed.emit()
		spawn_explosion_scene.rpc_id(1)
		#var explosion_node = explosion_scene.instantiate()
		#get_parent().add_child(explosion_node, true)
		#explosion_node.global_position = global_position
		#@warning_ignore("integer_division")
		#explosion_node.scale *= (sprite.texture.get_width() / 400)
		queue_free_on_server.rpc_id(1)
		
@rpc("any_peer", "call_local")
func spawn_explosion_scene():
	var explosion = explosion_scene.instantiate()
	@warning_ignore("integer_division")
	explosion.scale *= (sprite.texture.get_width() / 400)
	add_sibling(explosion, true)

@rpc("any_peer", "call_local", "reliable")
func queue_free_on_server():
	queue_free()
	
func _on_detection_area_body_entered(object: Node2D):
	print(object, " entered the detection area")
	var object_brain = object.get_parent()
	if object in get_tree().get_nodes_in_group("Buildings"):
		object_brain = object
	if object_brain.get_team() == team:
		allies_in_area.append(object)
	else:
		enemies_in_area.append(object)

# Signal handler for body exited
func _on_detection_area_body_exited(object: Node2D):
	print(object, " exited the detection area")
	var object_brain = object.get_parent()
	if object.is_in_group("Buildings"):
		object_brain = object
	if object_brain.get_team() == team:
		allies_in_area.erase(object)
	else:
		enemies_in_area.erase(object)

func _on_area_2d_body_exited(body: Node2D):
	close_mining_units.erase(body)
	
func _on_area_2d_body_entered(body: Node2D):
	if !(body.get_parent() in get_tree().get_nodes_in_group("Units")):
		return
	if body.get_parent().team == team and body.get_parent().can_mine == true: 
			close_mining_units.append(body)


@rpc("any_peer", "call_local", "reliable")
func spawn_bullet(called_by: int, target_name: String, spawn_pos: Vector2, damage, speed):
	var new_bullet = preload("res://Bullet/Bullet.tscn").instantiate()
	new_bullet.target_brain_name = target_name
	new_bullet.damage = damage
	new_bullet.speed = speed
	new_bullet.global_position = spawn_pos
	add_sibling(new_bullet, true)

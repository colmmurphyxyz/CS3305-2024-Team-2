extends Node2D
class_name Unit

var team:String = str(randi_range(1,2))
@export var hp:int= 8
@export var attack_damage:int = 2

var selected:bool = false
var selected_texture_path:String
@export var selection_sprite:Sprite2D

#Light radius, fog dispersal radius and detection radius tied to same value
@export var visible_radius_size:int = 2
var light:PointLight2D
var light_texture_path:String
var detection_area:Area2D

var state
var state_factory


var units_within_attack_range =[]
var current_target:CharacterBody2D=null
var is_chasing:CharacterBody2D = null
@export var attack_speed:int=1
@export var bullet : PackedScene

@onready var body:CharacterBody2D = $Body 
@onready var sprite2d:Sprite2D = $Body/Sprite2D

@onready var attack_area=$Body/AttackArea
@onready var attack_area_shape=$Body/AttackArea/CollisionShape2D
func _ready():
	add_to_group("Units")	
	#State system setup
	state_factory = StateFactory.new()
	change_state("idle")
	if team == "1":
		sprite2d.texture = load("res://Assets/unit_temp2.png")
	sprite2d.material.set("shader_param/shader_enabled",false)
	#Selection sprite setting up
	
	
	selection_sprite = Sprite2D.new()
	body.add_child(selection_sprite)
	selection_sprite.z_index=RenderingServer.CANVAS_ITEM_Z_MIN+34
	selected_texture_path = "res://Assets/pointLightTexture.webp"
	selection_sprite.texture = load(selected_texture_path)
	selection_sprite.visible=false
	
	#Light setting
	light = PointLight2D.new()
	body.add_child(light)
	light.scale=Vector2(visible_radius_size,visible_radius_size)
	light.texture=load("res://Assets/pointLightTexture.webp")
	light.blend_mode=Light2D.BLEND_MODE_MIX
	#Detection Radius
	detection_area = Area2D.new()
	body.add_child(detection_area)
	detection_area.scale=Vector2(visible_radius_size,visible_radius_size)
	
func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	#replace null with animated sprite when animating
	state.setup(Callable(self, "change_state"), null, self)
	state.name = "current_state"
	add_child(state)

func get_team():
	return team

func select():
	selected = true
	selection_sprite.visible=true
	sprite2d.material.set("shader_param/shader_enabled",true)
	
func deselect():
	selected=false
	selection_sprite.visible=false
	sprite2d.material.set("shader_param/shader_enabled",false)

func path_to_point(point:Vector2):
	body.target = point
	body.get_collision_mask_value(3)
	change_state("moving")
	
func reset_chase():
	is_chasing=null
func set_chase(chase:CharacterBody2D):
	is_chasing=chase
	
func damage(damage_amount):
	hp-=damage_amount
	if hp <= 0:
		queue_free()
#Enemies that enter into attack area are sorted by distance from unit
#Unit will try to select closest one when in idle state
func _on_attack_area_body_entered(body):
	if body.get_parent().team != team:
		units_within_attack_range.append(body)
		sort_enemies_in_attack_area_by_distance(units_within_attack_range)
	
func _on_attack_area_body_exited(body):
	units_within_attack_range.erase(body)

func sort_enemies_in_attack_area_by_distance(list):
	 # Custom comparison function for sorting based on size
	
	var list_compare_lamda = func compare_items(a, b) -> int:
		var a_distance = a.global_position.distance_to(body.global_position)
		var b_distance = b.global_position.distance_to(body.global_position)
		if a_distance < b_distance:
			return -1  # a is smaller than b
		elif a_distance > b_distance:
			return 1   # b is smaller than a
		else:
			return 0   # a and b are the same size

		# Sort the list based on the custom comparison function
		list.sort_custom(self, "list_compare_lamda")

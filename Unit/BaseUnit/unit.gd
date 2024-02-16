extends Node2D
class_name Unit

#Building stuff
@export_group("Main Stats")
## 1 or 2
@export var team:String = "1"
@export var hp:int= 8
@export var attack_damage:int = 2
@export var speed =300
#Selection
var selected:bool = false
var selected_texture_path:String

#Light radius, fog dispersal radius and detection radius tied to same value
@export var visible_radius_size:int = 2
var light:PointLight2D
var light_texture_path:String
var detection_area:Area2D
#State
@export var state: State
var state_factory
var state_name:String

#Enemy detection/attack
var units_within_attack_range =[]
var current_target:CharacterBody2D=null
var is_chasing:CharacterBody2D = null
@export_subgroup("Combat Properties")
@export var melee:bool = false
@export var attack_speed:float=1
@export var bullet : PackedScene
@export var bullet_speed:int = 300
@export var attack_frame:int = 0
@export var explosion_scene: PackedScene = preload("res://Unit/BaseUnit/Explosion.tscn")
@export_subgroup("Building Properties")
#Building things
@export var can_build:bool=false
@export var can_mine:bool=true
var target_building:Node2D = null

#Mining
var carrying_ore:bool = false
#Node accessing
@onready var body:CharacterBody2D = $Body 
@onready var sprite2d:AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var healthbar = $Body/Healthbar
@onready var attack_area=$Body/AttackArea
@onready var attack_area_shape=$Body/AttackArea/CollisionShape2D
@onready var hit_timer:Timer = Timer.new()
var width:int
func _ready():
	
	add_to_group("Units")	
	#State system setup
	state_factory = StateFactory.new()
	change_state("idle")
	healthbar.max_value=hp
	healthbar.value=hp
	
	add_child(hit_timer)
	hit_timer.wait_time=.1
	hit_timer.start()
	hit_timer.timeout.connect(hit_timer_timeout)

	width=sprite2d.sprite_frames.get_frame_texture("idle",0).get_width()
	
	if team == "1":
		pass
		#sprite2d.texture = load("res://Assets/unit_temp.png")
	

	sprite2d.material.set("shader_param/shader_enabled",false)
	#Selection sprite setting up
	sprite2d.rotation=randi_range(0,360)
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
	#Attack Radius
func change_state(new_state_name):
	
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state_name=new_state_name
	#replace null with animated sprite when animating
	state.setup(Callable(self, "change_state"), null, self)
	state.name = "current_state"
	add_child(state)

func get_team():
	return team

func select():
	selected = true
	sprite2d.material.set("shader_param/shader_enabled",true)
	
func deselect():
	selected=false
	sprite2d.material.set("shader_param/shader_enabled",false)

func path_to_point(point:Vector2):
	body.target = point
	body.get_collision_mask_value(3)
	change_state("moving")
	
func reset_chase():
	is_chasing=null

func get_state()->String:
	return state_name
	
func load_ore():
	if carrying_ore == false:
		carrying_ore=true
		var ore_sprite:Sprite2D = Sprite2D.new()
		ore_sprite.texture=load("res://Assets/iron.png")
		ore_sprite.name="Ore"
		body.add_child(ore_sprite)
	else:
		body.remove_child(body.get_node("Ore"))
		carrying_ore=false
			
func set_chase(chase:CharacterBody2D):
	is_chasing=chase
func set_target_building(building:StaticBody2D):
	target_building=building
	
func damage(damage_amount):
	sprite2d.material.set("shader_param/active",true)
	hp-=damage_amount
	healthbar.value=hp
	if hp <= 0:
		spawn_explosion_scene.rpc_id(1, body.position)
		#var explosion = explosion.instantiate()
		#get_parent().add_child(explosion)
		#explosion.global_position = body.global_position
		#explosion.scale*=(width/32)
		queue_free()

func hit_timer_timeout():
	sprite2d.material.set("shader_param/active",false)
#Enemies that enter into attack area are sorted by distance from unit
#Unit will try to select closest one when in idle state
func _on_attack_area_body_entered(enemy_body):
	if enemy_body.get_parent().team != team:
		units_within_attack_range.append(enemy_body)
		sort_enemies_in_attack_area_by_distance(units_within_attack_range)
	
func _on_attack_area_body_exited(enemy_body):
	units_within_attack_range.erase(enemy_body)
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
		
@rpc("any_peer", "call_local")
func spawn_explosion_scene(spawn_pos: Vector2):
	var explosion = explosion_scene.instantiate()
	explosion.position = spawn_pos
	explosion.scale *= (width / 32)
	add_sibling(explosion, true)

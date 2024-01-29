extends Node2D
class_name Unit

var team:String = ""
@export var hp:int= 10
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

@onready var body:CharacterBody2D = $Body 

func _ready():
	add_to_group("Units")	
	#State system setup
	state_factory = StateFactory.new()
	change_state("idle")
	#Selection sprite setting up
	selection_sprite = Sprite2D.new()
	body.add_child(selection_sprite)
	selection_sprite.z_index=RenderingServer.CANVAS_ITEM_Z_MIN+1
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

func select():
	selected = true
	selection_sprite.visible=true
	
func deselect():
	selected=false
	selection_sprite.visible=false

func path_to_point(point:Vector2):
	body.target = point
	change_state("moving")

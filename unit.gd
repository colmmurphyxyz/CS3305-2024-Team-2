extends Node2D

var team:String = ""
var hp:int= 10
var attack_damage:int = 2

var speed=60
var target = Vector2.ZERO
var velocity = Vector2.ZERO
var target_max=1


var selected:bool = false
var selected_texture_path:String
var selection_sprite:Sprite2D

#Light radius, fog dispersal radius and detection radius tied to same value
var visible_radius_size:int = 5
var light:PointLight2D
var light_texture_path:String

var detection_area:Area2D

func _ready():
	add_to_group("Units")
	
	#Selection sprite setting up
	selection_sprite = Sprite2D.new()
	add_child(selection_sprite)
	selection_sprite.z_index=RenderingServer.CANVAS_ITEM_Z_MIN+1
	selected_texture_path = "res://Assets/pointLightTexture.webp"
	selection_sprite.texture = load(selected_texture_path)
	selection_sprite.visible=false
	
	#Light setting
	light = PointLight2D.new()
	add_child(light)
	light.scale=Vector2(visible_radius_size,visible_radius_size)
	light.texture=load("res://Assets/pointLightTexture.webp")
	
	#Detection Radius
	detection_area = Area2D.new()
	add_child(detection_area)
	detection_area.scale=Vector2(visible_radius_size,visible_radius_size)

func select():
	selected = true
	selection_sprite.visible=true
	
func deselect():
	selected=false
	selection_sprite.visible=false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x+=1

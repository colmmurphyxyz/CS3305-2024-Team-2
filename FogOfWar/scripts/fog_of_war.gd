extends Node2D
@onready var fogWidth =  get_tree().get_root().get_size().x*2
@onready var fogHeight =  get_tree().get_root().get_size().y*2
@onready var fog: Sprite2D = get_node("fog")
# exports for editor

@export var LightTexture: CompressedTexture2D = load("res://Assets/Light.png")
@export var lightWidth = 300
@export var lightHeight = 300
@export var Player: CharacterBody2D
@export var debounce_time = 0.01

# debounce counter helper
var time_since_last_fog_update = 0.0
var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

var interval:float = .2
var timer:float =0.0

# here we cache things when Node2D is ready
func _ready():
  # get Image from CompressedTexture2D and resize it
	lightImage = LightTexture.get_image()
	lightImage.resize(lightWidth, lightHeight)
	light_offset = Vector2(lightWidth/2, lightHeight/2)
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
	
	fogImage = Image.create(fogWidth, fogHeight, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color.BLACK)
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture
	

	for unit in get_tree().get_nodes_in_group("Units"):
				var light_radius = unit.visible_radius_size*180
				lightImage.resize(light_radius, light_radius)
				light_offset = Vector2(light_radius/2, light_radius/2)
				light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
				update_fog(unit.body.global_position)


# update our fog
func update_fog(pos):
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)

func _process(delta):
	timer+=delta
	if timer>=interval:
		for unit in get_tree().get_nodes_in_group("Units"):
			if unit.body.velocity != Vector2.ZERO:
				var light_radius = unit.visible_radius_size*180
				lightImage.resize(light_radius, light_radius)
				light_offset = Vector2(light_radius/2, light_radius/2)
				light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
				update_fog(unit.body.global_position)
				timer = 0

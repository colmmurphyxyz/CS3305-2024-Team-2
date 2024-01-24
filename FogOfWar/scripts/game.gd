extends Node2D
@onready var fogWidth =  get_tree().get_root().get_size().x*2
@onready var fogHeight =  get_tree().get_root().get_size().y*2
# exports for editor
@export var fog: Sprite2D
@export var LightTexture: CompressedTexture2D
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

  # get Rect2 from our Image to use it with .blend_rect() later

  # update fog once or player will be under fog until you start move
	update_fog(Player.position)
	

# update our fog
func update_fog(pos):
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)

# main render loop. Here we don't need to call update every iteration.
# So we are using debounce here to execute code each "debounce_time"
# If debounce us ready, now we can check is character moving. And update fog if it's moving.
# Here I don't use single if block for debounce + player input because we don't need to check input
# if debounce is not ready. 
func _process(delta):
	for unit in get_tree().get_nodes_in_group("Units"):
		var light_radius = unit.detectionRadiusSize*180
		lightImage.resize(light_radius, light_radius)
		light_offset = Vector2(light_radius/2, light_radius/2)
		light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
		print(unit.detectionRadiusSize,unit.name)
		update_fog(unit.position)
		
### If you want to stick to mouse
### make sure you add optimizations here
#func _input(event):
#	update_fog(get_node("player").position)

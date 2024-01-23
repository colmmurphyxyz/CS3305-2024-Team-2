extends CharacterBody2D

@export var speed = 500
@export var acceleration = 0.4
@export var detectionRadiusSize = 5

@onready var light: PointLight2D = $Light 
@onready var detectionRadius: Area2D = $DetectionRadius

func _ready():
	light.scale=Vector2(detectionRadiusSize,detectionRadiusSize)
	detectionRadius.scale=Vector2(detectionRadiusSize,detectionRadiusSize)
func get_input():
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	return Vector2(horizontal, vertical)

func _physics_process(_delta):
	var direction = get_input()
	velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	move_and_slide()
	


	


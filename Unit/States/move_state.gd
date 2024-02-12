extends State
class_name MovingState

var count:int = 20
var check_position_timer:int = count
var last_position:Vector2
@onready var attack_radius = persistent_state.attack_area_shape.shape.radius
#@onready var body:CharacterBody2D = $Body
# Called when the node enters the scene tree for the first time.
var body:CharacterBody2D
func _ready():
	if persistent_state.melee==true:
		attack_radius = 40
	body = persistent_state.body
	last_position=body.global_position
	persistent_state.sprite2d.play("move")

func _process(delta):
			
	if body.target.distance_squared_to(body.global_position) < 300:
		body.target =body.global_position
		body.velocity = Vector2.ZERO
		persistent_state.change_state("idle")
	
	#If object has a valid body to chase, repath
	if (is_instance_valid(persistent_state.is_chasing) and persistent_state.is_chasing !=null):
			if body.global_position.distance_to(persistent_state.is_chasing.global_position) < attack_radius:
				persistent_state.path_to_point(persistent_state.body.global_position)			
				persistent_state.change_state("attacking")
			else:
				persistent_state.path_to_point(persistent_state.is_chasing.global_position)
			
		
	


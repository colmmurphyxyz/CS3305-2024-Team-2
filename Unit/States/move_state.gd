extends State
class_name MovingState

var count:int = 20
var check_position_timer:int = count
var last_position:Vector2
#@onready var body:CharacterBody2D = $Body
# Called when the node enters the scene tree for the first time.
var body:CharacterBody2D
func _ready():

	print("moving")
	body = persistent_state.body
	last_position=body.global_position

func _process(delta):
			
	if body.target.distance_squared_to(body.global_position) < 300:
		body.target =body.global_position
		body.velocity = Vector2.ZERO
		persistent_state.change_state("idle")
		
	


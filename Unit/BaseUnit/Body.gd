extends CharacterBody2D

var speed:int
var target:Vector2 = Vector2.ZERO
var target_max:int=1
#navigation
var nav_path : PackedVector2Array
@onready var nav_agent:NavigationAgent2D = $NavigationAgent2D

#Path finding of unit, to make it move, give it a target
func _ready():
	#Set target to self if nesecessary 
	target = get_position_delta()
	speed=get_parent().speed
func _physics_process(delta):

	var direction:Vector2 = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocty:Vector2 = direction*speed
	velocity=intended_velocty
	get_parent().sprite2d.rotation = velocity.angle()+180
	move_and_slide()
	
func create_path():
		nav_agent.target_position = target

func _on_timer_timeout():
	create_path()


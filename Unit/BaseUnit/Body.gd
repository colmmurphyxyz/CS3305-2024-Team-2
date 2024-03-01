extends CharacterBody2D

@export var target:Vector2 = Vector2.ZERO
var is_building=false
var speed: int
var target_max: int = 1
#navigation
var nav_path: PackedVector2Array
var nav_loaded: bool = false
@onready var nav_agent:NavigationAgent2D = $NavigationAgent2D

#Path finding of unit, to make it move, give it a target
func _ready():
	#Set target to self if nesecessary 
	target = get_position_delta()
	speed=get_parent().speed

func _physics_process(delta):

	if !nav_loaded:
		nav_loaded = true
		return
	if !is_multiplayer_authority():
		return
	var direction:Vector2 = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocty:Vector2 = direction*speed
	velocity=intended_velocty
	#if is_instance_valid(get_parent().ray_manager):
		#for ray:RayCast2D in get_parent().ray_manager.get_children():
			#if ray.is_colliding():
				#var collision_normal = ray.get_collision_normal()
				#velocity=collision_normal*50
	move_and_slide()
	

	
func create_path():
		nav_agent.target_position = target
	
func _on_timer_timeout():
	pass


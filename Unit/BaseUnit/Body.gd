extends CharacterBody2D

var target:Vector2 = Vector2.ZERO
var speed: int
#navigation
var nav_path: PackedVector2Array
@onready var map_RID:RID = get_world_2d().get_navigation_map()
var pathing:bool = false
var pathing_point:int = 0 
var path_points_packed:PackedVector2Array


#Path finding of unit, to make it move, give it a target
func _ready():
	#Set target to self if nesecessary 
	target = get_position_delta()
	speed=get_parent().speed


#Called by selection system on right click of new position
func create_path():
		unit_path_new(target)
		
func unit_path_new(wanted_goal:Vector2) -> void:
	var safe_goal:Vector2 = NavigationServer2D.map_get_closest_point(map_RID,wanted_goal)
	var time1=Time.get_ticks_msec()

	path_points_packed = NavigationServer2D.map_get_path(map_RID,global_position,safe_goal,true,1)
	pathing = true
	pathing_point = 0
	

func _physics_process(delta):

	if pathing:
		var path_next_point:Vector2 = path_points_packed[pathing_point] - global_position
		if path_next_point.length_squared() > 1.0:
			var velocity = (path_next_point.normalized()*delta) * speed*1.2
			global_position +=velocity
		else: #Path point reached
			if pathing_point < (path_points_packed.size() -1):
				pathing_point+=1 #Grab next path point
				_physics_process(delta)
			else:
				pathing=false

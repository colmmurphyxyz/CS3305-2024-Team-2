extends State
class_name InteractingWithBuildingState

#An inbetween state that checks if unit can build/mine, if they can, switch to that state, 
#else, just move to build/attack it
#Ugly if statement chain but necessary for all the cases but logic is fairly simple for all
func _ready():
	#Check if building is
	if persistent_state.target_building !=null and is_instance_valid(persistent_state.target_building):
		#IF building is not a team building
		if persistent_state.target_building.get_team() != persistent_state.team:
			persistent_state.target=persistent_state.target_building.get_body()
		else:
		#IF can mine
			if persistent_state.target_building in get_tree().get_nodes_in_group("Mines") and persistent_state.can_mine==true:
				persistent_state.change_state("mining")
			elif persistent_state.target_building in get_tree().get_nodes_in_group("Constructions") and persistent_state.can_build==true:
			#IF can build
				persistent_state.change_state("building")
			else:
			#Otherwise just path towards the building and do nothing
				persistent_state.path_toward(persistent_state.target_building.global_position)
				persistent_state.target_building = null
	else:
		persistent_state.change_state("idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

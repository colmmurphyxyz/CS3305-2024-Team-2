extends State
class_name InteractingWithBuildingState

#An inbetween state that checks if unit can build/mine, if they can, switch to that state, 
#else, just move to build/attack it
#Ugly if statement chain but necessary for all the cases but logic is fairly simple for all
func _ready():
	print("Interacting")
	#Check if building is
	if persistent_state.target_building !=null and is_instance_valid(persistent_state.target_building):
		if persistent_state.team==persistent_state.target_building.get_team():
			#IF building is not a team building
			if persistent_state.target_building.get_team() != persistent_state.team:
				persistent_state.body.target=persistent_state.target_building.position
			else:
			#IF can mine
				if persistent_state.target_building in get_tree().get_nodes_in_group("Mines") and persistent_state.can_mine==true and persistent_state.target_building.is_active == true:
					print("Interacting with mine")
					
					persistent_state.change_state("mining")
				elif persistent_state.target_building in get_tree().get_nodes_in_group("Constructions") and persistent_state.can_build==true:
				#IF can build
					persistent_state.change_state("building")
				else:
				#Otherwise just path towards the building and do nothing
					persistent_state.path_to_point(persistent_state.target_building.global_position)
					persistent_state.target_building = null
		else:
			#IF building is ENEMY
			print("ENEMY")
			persistent_state.current_target=persistent_state.target_building
			persistent_state.is_chasing=persistent_state.target_building
			persistent_state.change_state("attacking")
	else:
		persistent_state.change_state("idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends State
class_name BuildingState

func _ready():
	print("building")
	pass

func _process(_delta: float):
	if persistent_state.target_building != null and persistent_state.target_building.is_active==false:
		persistent_state.body.target=persistent_state.target_building.global_position
	else:
		persistent_state.change_state("idle")
		persistent_state.body.target=persistent_state.body.global_position
		

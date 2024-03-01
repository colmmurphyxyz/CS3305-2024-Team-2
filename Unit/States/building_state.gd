extends State
class_name BuildingState

func _ready():
	print("building")
	pass

func _process(_delta: float):
	print(persistent_state.target_building)
	if persistent_state.target_building != null:
		persistent_state.body.target=persistent_state.target_building.global_position
		persistent_state.body.create_path()
	else:
		persistent_state.change_state("idle")
		persistent_state.body.target=persistent_state.body.global_position
		

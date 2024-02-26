extends State
class_name MiningState

func _ready():
	print("mining")
	pass

func _process(_delta: float):
	#Ore will be granted by mine, so when it gets ore from mine, path back to base
	if persistent_state.target_building == null:
		persistent_state.change_state("idle")
	if persistent_state.carrying_ore==false and persistent_state.target_building != null :
		persistent_state.body.target=persistent_state.target_building.global_position
		
	else:
		persistent_state.path_to_point(GameManager.player_hq.global_position)

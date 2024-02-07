extends State
class_name MiningState

func _ready():
	print("mining")
	pass

func _process(delta):
	#Ore will be granted by mine, so when it gets ore from mine, path back to base
	if persistent_state.carrying_ore==false:
		persistent_state.body.target=persistent_state.target_building.global_position
	else:
		#We need to setup team desginated HQ for this to path to, for now just path to 0,0
		persistent_state.body.target=Vector2(0,0)
		pass

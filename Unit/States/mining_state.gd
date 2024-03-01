extends State
class_name MiningState
var pathing:bool=false

func _ready():
	print("mining")
	print("carrying ore: ",persistent_state.carrying_ore)
	pass

func _process(_delta: float):

	persistent_state.sprite2d.rotation = persistent_state.body.velocity.angle()+4.71239		
	#Ore will be granted by mine, so when it gets ore from mine, path back to base
	#print(persistent_state.target_building)
	if persistent_state.target_building == null:
		persistent_state.change_state("idle")
	if persistent_state.carrying_ore==false and persistent_state.target_building != null:
		persistent_state.body.target=persistent_state.target_building.global_position
		persistent_state.body.create_path()
		pathing=true
		
	else:
		persistent_state.path_to_point(GameManager.player_hq.global_position)

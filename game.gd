extends Node2D

const TEAM_1_HQ_POSITION: Vector2 = Vector2(500, 1250)
const TEAM_2_HQ_POSITION: Vector2 = Vector2(750, 1600)

func _ready():
	# spawn HQ's for both teams
	# only call RPC from server, to avoid dupicate buildings at the same location
	# func place_building(scene_path: String, called_by: int, spawn_pos: Vector2):
	if multiplayer.get_unique_id() == 1:
		$Buildings.place_building.rpc_id(1,
			"res://Buildings/HQ/hq.tscn",
			GameManager.Host["id"],
			TEAM_1_HQ_POSITION
			)
		$Buildings.place_building.rpc_id(1,
			"res://Buildings/HQ/hq.tscn",
			GameManager.Client["id"],
			TEAM_2_HQ_POSITION
			)

func _process(_delta: float):
	pass

extends Node2D

func _ready():
	# spawn HQ's for both teams
	# only call RPC from server, to avoid dupicate buildings at the same location
	# func place_building(scene_path: String, called_by: int, spawn_pos: Vector2):
	if multiplayer.get_unique_id() == 1:
		$Buildings.place_building.rpc_id(1,
			"res://Buildings/HQ/hq.tscn",
			GameManager.Host["id"],
			GameManager.TEAM_1_HQ_POSITION
			)
		$Buildings.place_building.rpc_id(1,
			"res://Buildings/HQ/hq.tscn",
			GameManager.Client["id"],
			GameManager.TEAM_2_HQ_POSITION
			)
		GameManager.player_hq = $SpawnRoot.get_node("hq1")
	if multiplayer.get_unique_id() != 1:
		GameManager.player_hq = $SpawnRoot.get_node("hq2")

func _process(_delta: float):
	pass

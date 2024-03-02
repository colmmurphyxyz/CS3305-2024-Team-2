extends Node2D

func _ready():
	# set this scene's camera to be the current
	# otherwise we keep using the camera from the main menu scene
	$PlayerCamera/Camera2D.make_current()
	# spawn HQ's for both teams
	# only call RPC from server, to avoid dupicate buildings at the same location
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
		GameManager.player_hq = $SpawnRoot.get_node("Hq")
		# set camera position to be on player's hq
		$PlayerCamera/Camera2D.position = GameManager.player_hq.position
		# set GameManager.player_hq field and camera position on client-side
		set_client_hq_and_camera.rpc_id(GameManager.Client["id"])
		
@rpc("authority", "call_remote", "reliable")
func set_client_hq_and_camera():
	GameManager.player_hq = $SpawnRoot.get_node("Hq2")
	$PlayerCamera/Camera2D.position = GameManager.player_hq.position

func _process(_delta: float):
	pass

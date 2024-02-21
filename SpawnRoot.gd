extends Node2D

func _ready():
	# set multiplayer authority on units/buildings already in the scene
	var client_id: int = GameManager.Client["id"] if GameManager.Client.has("id") else "2"
	for node in get_children():
		for child in node.get_children():
			child.set_multiplayer_authority(
				1 if node.team == "1" else client_id,
				true
			)

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_S:
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Sniper/sniper.tscn", \
						get_global_mouse_position())
			KEY_B:
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Bruiser/bruiser.tscn", \
						get_global_mouse_position())
			KEY_D:
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Drone/drone.tscn", \
						get_global_mouse_position())
			KEY_W:
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Warden/warden.tscn", \
						get_global_mouse_position())
			KEY_T:
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Scout/scout.tscn", \
						get_global_mouse_position())
				
@rpc("any_peer", "call_local", "reliable")
func spawn_unit(called_by: int, scene_path: String, spawn_pos: Vector2):
	var new_unit: Node2D = load(scene_path).instantiate()
	new_unit.global_position = spawn_pos
	new_unit.team = "1" if called_by == 1 else "2"
	add_child(new_unit, true)
	set_authority.rpc(new_unit.name, called_by)
	
@rpc("authority", "call_local", "reliable")
func set_authority(node_name: String, auth: int):
	var new_node = get_node(node_name)
	new_node.set_multiplayer_authority(auth, true)
	new_node.add_to_group("Units")


func _on_child_entered_tree(node: Node):
	pass

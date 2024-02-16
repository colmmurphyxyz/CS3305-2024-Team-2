extends Node2D

func _input(event):
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
		#spawn_sniper.rpc_id(1, multiplayer.get_unique_id(), \
				#get_global_mouse_position())
				
@rpc("any_peer", "call_local")
func spawn_unit(called_by: int, scene_path: String, spawn_pos: Vector2):
	var new_unit = load(scene_path).instantiate()
	new_unit.global_position = spawn_pos
	new_unit.team = "1" if called_by == 1 else "2"
	add_child(new_unit, true)
	set_authority.rpc(new_unit.name, called_by)
	
@rpc("authority", "call_local")
func set_authority(node_name: String, auth: int):
	#get_node(node_name).get_node("MultiplayerSynchronizer")\
			#.set_multiplayer_authority(auth)
	get_node(node_name).set_multiplayer_authority(auth, true)


func _on_child_entered_tree(node: Node):
	print("child entered: ", node.to_string(), node.name)
	if node.name.contains("Bullet"):
		print("pew pew")

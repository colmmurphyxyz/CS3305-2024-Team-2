extends Node2D

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_S:
				print("spawning new sniper")
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Sniper/sniper.tscn", \
						get_global_mouse_position())
			KEY_B:
				print("spawning bruiser")
				spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Bruiser/bruiser.tscn", \
						get_global_mouse_position())
			KEY_D:
				print("spawning drone")
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
	
@rpc("any_peer", "call_local")
func add_node_to_spawn_root(called_by: int, new_node: Node):
	add_child(new_node, true)
	set_authority.rpc(new_node.name, called_by)
	
@rpc("any_peer", "call_local")
func spawn_sniper(called_by: int, spawn_pos: Vector2):
	var new_sniper = preload("res://Unit/UnitTypes/Sniper/sniper.tscn").instantiate()
	new_sniper.global_position = spawn_pos
	new_sniper.team = "1" if called_by == 1 else "2"
	add_child(new_sniper, true)
	#new_sniper.get_node("MultiplayerSynchronizer").set_multiplayer_authority(called_by)
	set_authority.rpc(new_sniper.name, called_by)
	
@rpc("authority", "call_local")
func set_authority(node_name: String, auth: int):
	get_node(node_name).get_node("MultiplayerSynchronizer")\
			.set_multiplayer_authority(auth)


func _on_child_entered_tree(node: Node):
	print("child entered: ", node.to_string(), node.name)
	if !node.name.contains("Bullet"):
		print("not a bullet")
		return
	if true:
		print("pew pew")
		add_node_to_spawn_root.rpc_id(1, multiplayer.get_unique_id(), node)

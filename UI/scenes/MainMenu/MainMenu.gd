extends Control

const CAMERA_MOVE_SPEED: int = 15

var peer: ENetMultiplayerPeer

@onready var game_scene: PackedScene = preload("res://game.tscn")
@onready var camera: Camera2D = $MainMenuCamera


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
func _process(delta: float):
	camera.position.x += CAMERA_MOVE_SPEED * delta

# called on all clients and server
func peer_connected(id: int):
	print("Player connected ", id)

# called on all peers
func peer_disconnected(id: int):
	print("Player disconnected ", id)

# called only on the connecting peer
func connected_to_server():
	print("Connected to server!")
	GameManager.Client = {
		"name": $CanvasLayer/PlayerNameField.text,
		"id": multiplayer.get_unique_id(),
	}
	GameManager.team = "2"
	send_client_info_to_server.rpc_id(1, GameManager.Client.name, GameManager.Client.id)
	
# called only from clients
func connection_failed():
	printerr("Connection failed")
	
@rpc("authority", "call_remote", "reliable")
func send_host_info_to_client(name: String):
	GameManager.Host = {
		"name": name,
		"id": 1,
	}
	
@rpc("any_peer", "call_remote", "reliable")
func send_client_info_to_server(name: String, id: int):
	GameManager.Client = {
		"name": name,
		"id": id,
	}
	send_host_info_to_client.rpc_id(GameManager.Client.id, $CanvasLayer/PlayerNameField.text)

func _on_play_computer_button_pressed():
	if !_is_player_name_valid():
		_show_error_message("Please enter a name")
	else:
		get_tree().change_scene_to_packed(game_scene)


func _on_error_alert_label_show_timer_timeout():
	$CanvasLayer/ErrorAlertLabel.visible = false


func _on_host_game_button_pressed():
	if !_is_player_name_valid():
		_show_error_message("Please enter a name")
	elif !_is_host_port_valid():
		_show_error_message("Enter a port number greater than 1024")
	else:
		GameManager.Host = {
			"name": $CanvasLayer/PlayerNameField.text,
			"id": 1
		}
		GameManager.team = "1"
		var port = int($CanvasLayer/HostPortField.text)
		print("using port ", port)
		peer = ENetMultiplayerPeer.new()
		# create server on given port, with max 2 connections (including self)
		var error = peer.create_server(port, 2)
		if error != OK:
			printerr("Cannot host: ", error)
		peer.get_host().compress(ENetConnection.COMPRESS_NONE)
		multiplayer.set_multiplayer_peer(peer)
		print("waiting for players")
		
		
func _on_join_game_button_pressed():
	if !_is_join_address_valid():
		_show_error_message("Invalid IP address")
		return
	elif !_is_join_port_valid():
		_show_error_message("Enter a port number greater than 1024")
		return
	var address = $CanvasLayer/JoinAddressField.text
	var port = int($CanvasLayer/JoinPortField.text)
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	print("Connecting to %s on port %d" % [address, port])
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
		
		
func _is_player_name_valid() -> bool:
	return $CanvasLayer/PlayerNameField.text != ""
	
func _is_host_port_valid() -> bool:
	if $CanvasLayer/HostPortField.text == "":
		return true
	return int($CanvasLayer/HostPortField.text) > 1024
	
func _is_join_address_valid() -> bool:
	return $CanvasLayer/JoinAddressField.text.is_valid_ip_address()
	
func _is_join_port_valid() -> bool:
	if $CanvasLayer/JoinPortField.text == "":
		return true
	return int($CanvasLayer/JoinPortField.text) > 1024
	
func _show_error_message(message: String):
	$CanvasLayer/ErrorAlertLabel.text = message
	$CanvasLayer/ErrorAlertLabel.visible = true
	$ErrorAlertLabelShowTimer.start()
		
@rpc("any_peer", "call_local")
func start_game():
	var scene = game_scene.instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("PlayerCamera").is_locked = true
	self.hide()


func _on_start_lan_game_button_pressed():
	start_game.rpc()

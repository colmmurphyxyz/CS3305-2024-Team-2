extends Control

@onready var game_scene: PackedScene = preload("res://multiplayer_test.tscn")

var peer: ENetMultiplayerPeer


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# called on all clients and server
func peer_connected(id: int):
	print("Player connected ", id)

# called on all peers
func peer_disconnected(id: int):
	print("Player disconnected ", id)

# called only on the connecting peer
func connected_to_server():
	print("Connected to server!")
	exchange_player_info($PlayerNameField.text, multiplayer.get_unique_id())
	
# called only from clients
func connection_failed():
	printerr("Connection failed")
	
@rpc("any_peer")
func exchange_player_info(name: String, id: int):
	# if receiving client info, executed on host machine
	if id != 1:
		GameManager.Client = {
			"name": name,
			"id": id,
		}
		GameManager.team = "2"
	else: # receiving host info, executed on client side
		GameManager.Host = {
			"name": name,
			"id": 1,
		}
		GameManager.team = "1"
	if id != 1 and multiplayer.is_server():
		exchange_player_info.rpc($PlayerNameField.text, "host",
				multiplayer.get_unique_id())

func _on_play_computer_button_pressed():
	if !_is_player_name_valid():
		_show_error_message("Please enter a name")
	else:
		get_tree().change_scene_to_packed(game_scene)


func _on_error_alert_label_show_timer_timeout():
	$ErrorAlertLabel.visible = false


func _on_host_game_button_pressed():
	if !_is_player_name_valid():
		_show_error_message("Please enter a name")
	elif !_is_host_port_valid():
		_show_error_message("Enter a port number greater than 1024")
	else:
		var port = int($HostPortField.text)
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
	var address = $JoinAddressField.text
	var port = int($JoinPortField.text)
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	print("Connecting to %s on port %d" % [address, port])
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
		
		
func _is_player_name_valid() -> bool:
	return $PlayerNameField.text != ""
	
func _is_host_port_valid() -> bool:
	if $HostPortField.text == "":
		return true
	return int($HostPortField.text) > 1024
	
func _is_join_address_valid() -> bool:
	return $JoinAddressField.text.is_valid_ip_address()
	
func _is_join_port_valid() -> bool:
	if $JoinPortField.text == "":
		return true
	return int($JoinPortField.text) > 1024
	
func _show_error_message(message: String):
	$ErrorAlertLabel.text = message
	$ErrorAlertLabel.visible = true
	$ErrorAlertLabelShowTimer.start()
		
@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://multiplayer_test.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()


func _on_start_lan_game_button_pressed():
	start_game.rpc()

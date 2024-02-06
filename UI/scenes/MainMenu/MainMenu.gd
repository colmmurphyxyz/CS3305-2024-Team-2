extends Control

@onready var game_scene: PackedScene = preload("res://game.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
		get_tree().change_scene_to_packed(game_scene)
		
func _on_join_game_button_pressed():
	if !_is_player_name_valid():
		_show_error_message("Please Enter a name")
	elif !_is_join_address_valid():
		_show_error_message("Invalid host address")
	elif !_is_join_port_valid():
		_show_error_message("Enter a port number greater than 1024")
	else:
		# idk what to do here
		pass
		
		
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
		

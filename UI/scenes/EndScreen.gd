extends Control

@onready var camera: Camera2D = $Camera2D

func _ready():
	# remove the game scene
	var game_scene = get_parent().get_node_or_null("Game")
	if game_scene != null:
		game_scene.queue_free()
	# set this scene's camera to be the current camera
	camera.make_current()
func _process(delta):
	pass


func _on_button_button_down():
	# close all active connections
	var main_menu = get_parent().get_node("MainMenu")
	var p: ENetMultiplayerPeer = main_menu.peer
	p.disconnect_peer(GameManager.Client["id"])
	p.disconnect_peer(GameManager.Host["id"])
	p.close()
	get_tree().get_root().get_node("MainMenu").set_main_menu_visibility(true)
	hide()

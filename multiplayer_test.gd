extends Node2D


func _ready():
	pass


func _process(_delta: float):
	pass
	
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_S:
		print("spawning new sniper")
		spawn_sniper.rpc_id(1, multiplayer.get_unique_id(), \
				get_global_mouse_position())
	
@rpc("call_local")
func spawn_sniper(called_by: int, spawn_pos: Vector2):
	var new_sniper = preload("res://Unit/UnitTypes/Sniper/sniper.tscn").instantiate()
	new_sniper.global_position = spawn_pos
	new_sniper.team = "1"
	$SpawnRoot.add_child(new_sniper, true)

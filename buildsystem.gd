extends Node2D

## Placed buildings will be children of this node.
## Unplaced children will be children of the node this script is attached to.
@export var building_root: Node
var building=true
var spawned_object = null
var selected_building_path: String = ""
var placement_allowed: bool = false
var deposit: bool = false
var mine: bool = false
var unobtainium = false

func _process(_delta: float):
	if Input.is_action_just_pressed("right_click"): # click at any time to cancel placing an object
		cancel_placement()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null && placement_allowed:
			print("placing(?)")
			if mine && deposit == false:
				print("No deposit found nearby")
			elif spawned_object.stop_following_mouse() == true:
				# have the server spawn and replicate a new building 
				# and delete one following the mouse
				print("can place")
				var spawn_pos: Vector2 = spawned_object.global_position
				spawned_object.visible = false
				spawned_object.free()
				spawned_object = null
				place_building.rpc_id(1, selected_building_path,
						multiplayer.get_unique_id(),
						spawn_pos
					)
				#spawned_object.sprite.modulate=Color(1,1,1)
				#spawned_object.remove_from_group("Constructions")
				mine = false
				
func _ready():
	pass

func spawn_object(resource):
	spawned_object = resource.instantiate()
	spawned_object.team = GameManager.team
	spawned_object.set_multiplayer_authority(multiplayer.get_unique_id())
	add_child(spawned_object, true)
	
func placing():
	if spawned_object != null && placement_allowed:
			if mine && deposit == false:
				print("No deposit found nearby")
			elif spawned_object.stop_following_mouse() == true: # if placed
				if mine:
					spawned_object.has_unobtainium = unobtainium
				spawned_object = null
				mine = false
	
func _button_press_select(building_name: String): # Arg passed by a signal for structure type
	cancel_placement()
	match building_name:
		"mine":
			mine = true
			selected_building_path = "res://Buildings/Mine/mine.tscn"
			spawn_object(preload("res://Buildings/Mine/mine.tscn"))
		"defence":
			selected_building_path = "res://Buildings/Defence/Defence.tscn"
			spawn_object(preload("res://Buildings/Defence/Defence.tscn"))
		"barracks":
			selected_building_path = "res://Buildings/Barracks/barracks.tscn"
			spawn_object(preload("res://Buildings/Barracks/barracks.tscn"))
		"laboratory":
			selected_building_path = "res://Buildings/Lab/Laboratory.tscn"
			spawn_object(preload("res://Buildings/Lab/Laboratory.tscn"))
		"fusion":
			selected_building_path = "res://Buildings/Fusion/FusionLab.tscn"
			spawn_object(preload("res://Buildings/Fusion/FusionLab.tscn"))
		_:
			print("Not valid structure")
	pass
	
# Prevent placing buildings on UI
func _button_entered():
	placement_allowed = false
	
func _button_exited():
	placement_allowed = true
	
# Check if a mine's placement is attempted in an ore area
func _deposit_enter():
	deposit = true
	
func _deposit_exit():
	deposit = false
	
# Special ore areas
func _unobtainium_area():
	unobtainium = true
	
func _not_unobtainium_area():
	unobtainium = false
	

func cancel_placement():
	if spawned_object != null:
		spawned_object.queue_free()
		spawned_object = null
		mine = false

# don't allow placement when mouse is over building selection VBox
func _on_v_box_container_mouse_entered():
	placement_allowed = false

func _on_v_box_container_mouse_exited():
	placement_allowed = true
	
@rpc("any_peer", "call_local", "reliable")
func place_building(scene_path: String, called_by: int, spawn_pos: Vector2):
	print("placing")
	var new_building: StaticBody2D = load(scene_path).instantiate()
	new_building.team = "1" if called_by == 1 else "2"
	new_building.global_position = spawn_pos
	new_building.is_placed = true
	new_building.is_following_mouse = false
	# set buildings to be full hp and active on spawn, for debugging reasons
	new_building.health = new_building.max_hp
	new_building.is_active = true
	
	building_root.add_child(new_building, true)
	new_building.add_to_group("Buildings")
	# set collision layers
	var layers = [1, 2, 12]
	var layers_mask = 0
	for n in layers:
		layers_mask |= int(pow(2, n-1)) 
	set_collision_layer.rpc(new_building.name, layers_mask)
	set_building_authority.rpc(new_building.name, called_by)
	
@rpc("authority", "call_local", "reliable")
func set_building_authority(node_name: String, auth: int):
	building_root.get_node(node_name).set_multiplayer_authority(auth, true)
	
@rpc("authority", "call_local", "reliable")
func set_collision_layer(node_name: String, layers: int):
	var building: StaticBody2D = building_root.get_node(node_name)
	building.collision_layer = layers
	building.collision_mask = 1 + 2

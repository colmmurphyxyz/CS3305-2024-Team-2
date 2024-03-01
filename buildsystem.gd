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
var unobtainium_field = false

var mine_cost = 10
var defence_cost = 20
var barracks_cost = 50
var laboratory_cost = 10 #unob
var fusionlab_cost = 50 #unob

var current_value_iron = 0
var current_value_unob = 0

@onready var error_timer: Timer = Timer.new()

@onready var vbox_node = get_parent().get_node("CanvasLayer/VBoxContainer")


func _process(_delta: float):
	if Input.is_action_just_pressed("right_click"): # click at any time to cancel placing an object
		cancel_placement()

	if Input.is_action_just_pressed("left_click"):
		if mine or GameManager.player_hq.global_position.distance_to(get_global_mouse_position()) < 300:
			hide_error_label()
			if spawned_object != null && placement_allowed:
				print("placing(?)")
				if mine && deposit == false:
					print("No deposit found nearby")
				elif spawned_object.stop_following_mouse() == true:
					# have the server spawn and replicate a new building 
					# and delete one following the mouse
					print("can place")
					var spawn_pos: Vector2 = spawned_object.global_position
					if mine:
						spawned_object.has_unobtainium = unobtainium_field
					spawned_object.visible = false
					spawned_object.free()
					spawned_object = null
					place_building.rpc_id(1, selected_building_path,
							multiplayer.get_unique_id(),
							spawn_pos,
							unobtainium_field,
						)
					#spawned_object.sprite.modulate=Color(1,1,1)
					#spawned_object.remove_from_group("Constructions")
					mine = false
					GameManager.iron -= current_value_iron
					GameManager.unobtainium -= current_value_unob
					current_value_iron = 0
					current_value_unob = 0
					
		else:
			if spawned_object != null:
				show_error_label()
				
				
		
func _ready():
	add_child(error_timer)  # Adding the Timer as a child of this node
	error_timer.timeout.connect(hide_error_label)
		#Update prices on buttons
	vbox_node.get_node("Mine").text = "Mine - %d Iron" % mine_cost
	vbox_node.get_node("Defence").text = "Defence - %d Iron" % defence_cost
	vbox_node.get_node("Barracks").text = "Barracks - %d Iron" % barracks_cost
	vbox_node.get_node("Laboratory").text = "Lab - %d Unob." % laboratory_cost
	vbox_node.get_node("Fusion Lab").text = "Fusion Lab - %d Unob." % fusionlab_cost

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
					spawned_object.has_unobtainium = unobtainium_field
				spawned_object = null
				mine = false
	
func _button_press_select(building_name: String): # Arg passed by a signal for structure type
	cancel_placement()
	match building_name:
		"mine":
			if GameManager.iron >= mine_cost:
				current_value_iron = mine_cost
				mine = true
				selected_building_path = "res://Buildings/Mine/mine.tscn"
				spawn_object(preload("res://Buildings/Mine/mine.tscn"))
		"defence":
			if GameManager.iron >= defence_cost:
				current_value_iron = defence_cost
				selected_building_path = "res://Buildings/Defence/Defence.tscn"
				spawn_object(preload("res://Buildings/Defence/Defence.tscn"))
		"barracks":
			if GameManager.iron >= barracks_cost:
				current_value_iron = barracks_cost
				selected_building_path = "res://Buildings/Barracks/barracks.tscn"
				spawn_object(preload("res://Buildings/Barracks/barracks.tscn"))
		"laboratory":
			if GameManager.unobtainium >= laboratory_cost:
				current_value_unob = laboratory_cost
				selected_building_path = "res://Buildings/Lab/Laboratory.tscn"
				spawn_object(preload("res://Buildings/Lab/Laboratory.tscn"))
		"fusion":
			if GameManager.unobtainium >= fusionlab_cost:
				current_value_unob = fusionlab_cost
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
	unobtainium_field = true
	
func _not_unobtainium_area():
	unobtainium_field = false
	

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
func place_building(scene_path: String, called_by: int, spawn_pos: Vector2, unobtainium_field: bool=false):
	print("placing")
	var new_building: StaticBody2D = load(scene_path).instantiate()
	new_building.team = "1" if called_by == 1 else "2"
	new_building.global_position = spawn_pos
	new_building.is_placed = true
	new_building.is_following_mouse = false
	# set buildings to be full hp and active on spawn, for debugging reasons
	new_building.health = new_building.max_hp
	new_building.is_active = true
	if mine:
		new_building.has_unobtainium = unobtainium_field
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
	
func show_error_label():
	if spawned_object != null:
		spawned_object.get_node("Label").visible = true
		error_timer.wait_time = 1.0
		error_timer.start()
	
func hide_error_label():
	if spawned_object != null and not mine:
		spawned_object.get_node("Label").visible = false

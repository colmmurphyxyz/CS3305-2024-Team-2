extends Base

const free_unit_time = 60.0
var free_spawn = free_unit_time
var control = null
var iron = 0 # replace with location of resource values

const drone_cost = 10
const bruiser_cost = 15
const sniper_cost = 15
const scout_cost = 15
const warden_cost = 10 #unob 
const screecher_cost = 15 #unob

var drone_button
var bruiser_button
var sniper_button
var scout_button
var warden_button
var screecher_button


func _ready():
	super._ready()
	max_hp = 1000.0
	health = max_hp / 2
	is_active = false
	control = get_node("VBoxContainer")
	control.hide()
	health=100
	
	drone_button = get_node("VBoxContainer/Drone")
	bruiser_button = get_node("VBoxContainer/Bruiser")
	sniper_button = get_node("VBoxContainer/Sniper")
	scout_button = get_node("VBoxContainer/Scout")
	warden_button = get_node("VBoxContainer/Warden")
	screecher_button = get_node("VBoxContainer/Fusion Screecher")
	
func _process(delta):
	super._process(delta)
	# toggle button uss based on criteria matched
	if GameManager.laboratory_placed:
		scout_button.disabled = false
		warden_button.disabled = false
	else:
		scout_button.disabled = true
		warden_button.disabled = true
	if GameManager.barrack_placed:
		bruiser_button.disabled = false
		sniper_button.disabled = false
		screecher_button.disabled = false
	else:
		bruiser_button.disabled = true
		sniper_button.disabled = true
		screecher_button.disabled = true
		
	#update text on buttons to show price
	drone_button.text = "(%d) Drone - %d Iron" % [round(free_spawn), drone_cost]
	bruiser_button.text = "Bruiser - %d Iron" % bruiser_cost
	sniper_button.text = "Sniper - %d Iron" % sniper_cost
	scout_button.text = "Scout - %d Iron" % scout_cost
	warden_button.text = "Warder - %d Unob." % warden_cost
	screecher_button.text = "Screecher - %d Unob." % screecher_cost
	
	if free_spawn > 0:
		free_spawn -= delta

# if tower is clicked show interaction menu
func _input(event):
	if event.is_action_pressed("right_click") and $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if get_global_mouse_position().distance_to(global_transform.origin) < 50:
			control.show()
		else:
			control.hide()
	pass
	
func getRandomPositionInDonut(innerRadius: float, outerRadius: float) -> Vector2:
	var center = self.global_position
	var angle = randf() * (2 * PI)
	var distance = randf_range(innerRadius, outerRadius)
	var x = center.x + distance * cos(angle)
	var y = center.y + distance * sin(angle)
	return Vector2(x, y)

func _spawn_unit(type: String):
	var spawn_position = getRandomPositionInDonut(35,60)
	match type:
		"drone":
			if free_spawn >= 0:
				free_spawn = free_unit_time
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Drone/drone.tscn", \
						spawn_position)
			elif iron > 10:
				free_spawn = free_unit_time
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Drone/drone.tscn", \
						spawn_position)
		"bruiser":
			if GameManager.barrack_placed and iron > 10:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Bruiser/bruiser.tscn", \
						spawn_position)
		"scout":
			if GameManager.laboratory_placed and iron > 10:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Scout/scout.tscn", \
						spawn_position)
		"sniper":
			if GameManager.barrack_placed and iron > 10:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Sniper/sniper.tscn", \
						spawn_position)
		"warden":
			if GameManager.laboratory_placed and iron > 10:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Warden/warden.tscn", \
						spawn_position)
		"screecher":
			if GameManager.barrack_placed and iron > 10:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/FusionScreecher/FusionScreecher.tscn", \
						spawn_position)
		_:
			print("Not valid button")

func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		var unit:Unit = body.get_parent()
		if unit.carrying_ore == true: 
			unit.load_ore()
			GameManager.iron += 1
			unit.change_state("mining")
			print(unit.carrying_ore,"SHOULD BE FALSE")
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
		
			
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

# called when the HQ is destroyed
func _on_building_destroyed():
	print("Team %s just lost. rip bozo" % team)
	#TODO Endgame logic

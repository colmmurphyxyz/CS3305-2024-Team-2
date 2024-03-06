extends Base

var control = null

const drone_cost = 10
const bruiser_cost = 20
const sniper_cost = 50
const scout_cost = 30
const warden_cost = 20 #unob 
const screecher_cost = 30 #unob

var drone_button
var bruiser_button
var sniper_button
var scout_button
var warden_button
var screecher_button
var end_scence = preload("res://UI/scenes/EndScreen.tscn")

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
	else:
		bruiser_button.disabled = true
		sniper_button.disabled = true
	if GameManager.fusion_lab_placed:
		screecher_button.disabled = false
	else:
		screecher_button.disabled = true
	#update text on buttons to show price
	drone_button.text = "Drone - %d Iron" % drone_cost
	bruiser_button.text = "Bruiser - %d Iron" % bruiser_cost
	sniper_button.text = "Sniper - %d Iron" % sniper_cost
	scout_button.text = "Scout - %d Iron" % scout_cost
	warden_button.text = "Warder - %d Unob." % warden_cost
	screecher_button.text = "Screecher - %d Unob." % screecher_cost

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
			if GameManager.iron >= drone_cost:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Drone/drone.tscn", \
						spawn_position)
				GameManager.iron -= drone_cost
		"bruiser":
			if GameManager.barrack_placed and GameManager.iron >= bruiser_cost:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Bruiser/bruiser.tscn", \
						spawn_position)
				GameManager.iron -= bruiser_cost
		"scout":
			if GameManager.laboratory_placed and GameManager.iron >= scout_cost:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Scout/scout.tscn", \
						spawn_position)
				GameManager.iron -= scout_cost
		"sniper":
			if GameManager.barrack_placed and GameManager.iron >= sniper_cost :
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Sniper/sniper.tscn", \
						spawn_position)
				GameManager.iron -= sniper_cost
		"warden":
			if GameManager.laboratory_placed and GameManager.unobtainium >= warden_cost:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/Warden/warden.tscn", \
						spawn_position)
				GameManager.unobtainium -= warden_cost
		"screecher":
			if GameManager.fusion_lab_placed and GameManager.unobtainium >= screecher_cost:
				get_parent().spawn_unit.rpc_id(1, multiplayer.get_unique_id(), \
						"res://Unit/UnitTypes/FusionScreecher/FusionScreecher.tscn", \
						spawn_position)
				GameManager.unobtainium -= screecher_cost
		_:
			print("Not valid button")

func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		var unit:Unit = body.get_parent()
		if unit.carrying_ore == true: 

			if body.get_node_or_null("Iron")==null:
				GameManager.unobtainium += 1
			else:
				GameManager.iron +=1
			unit.load_ore()
			unit.change_state("mining")
			print(GameManager.unobtainium)
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
		
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

# called when the HQ is destroyed
# only executed on the peer who is the authority of the building
func _on_building_destroyed():
	# hacky workaround to call this method on all peers
	show_end_scene.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func show_end_scene():
	var end_text:String = "You Win"
	if health <= 0:
		end_text="You Lose"
	var end_node = end_scence.instantiate()
	end_node.get_node("End").text=end_text
	get_tree().get_root().add_child(end_node)
	
	#get_tree().queue_delete()
	#var end_node = new
	#get_tree().add_child(end_scence)
	#get_tree().change_scene_to_packed(end_scence)
	#TODO Endgame logic

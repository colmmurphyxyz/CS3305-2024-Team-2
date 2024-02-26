extends Base

const free_unit_time = 60.0
var free_spawn = free_unit_time
var control = null
var iron = 0 # replace with location of resource values

func _ready():
	super._ready()
	max_hp = 100.0
	health = max_hp / 2
	is_active = false
	control = get_node("VBoxContainer")
	control.hide()
	
func _process(delta):
	super._process(delta)
	# toggle button uss based on criteria matched
	#if laboratory_placed:
		#get_node("VBoxContainer/Scout").set_disabled(false)
		#get_node("VBoxContainer/Warden").set_disabled(false)
	#else:
		#get_node("VBoxContainer/Scout").disabled = true
		#get_node("VBoxContainer/Warden").disabled = true
	#if barrack_placed:
		#get_node("VBoxContainer/Bruiser").disabled = false
		#get_node("VBoxContainer/Sniper").disabled = false
		#get_node("VBoxContainer/Marrauder").disabled = false
	#else:
		#get_node("VBoxContainer/Bruiser").disabled = true
		#get_node("VBoxContainer/Sniper").disabled = true
		#get_node("VBoxContainer/Marrauder").disabled = true
	if free_spawn > 0:
		free_spawn -= delta

# if tower is clicked show interaction menu
func _input(event):
	if event.is_action_pressed("right_click"):
		if get_global_mouse_position().distance_to(global_transform.origin) < 50:
			control.show()
		else:
			control.hide()
	pass
	
func getRandomPositionInDonut(innerRadius: float, outerRadius: float) -> Vector2:
	var center = 0 # get from GameManager
	var angle = randf() * (2 * PI)
	var distance = randf_range(innerRadius, outerRadius)
	var x = center.x + distance * cos(angle)
	var y = center.y + distance * sin(angle)
	return Vector2(x, y)

func _spawn_unit(type: String):
	var spawn_position = getRandomPositionInDonut(10,20)
	match type:
		# Set resources required
		"drone":
			if free_spawn <= 0:
				free_spawn = free_unit_time
				#spawn drone
				pass
			elif iron > 10:
				# buy unit, check unit cost, and iron from game controller
				pass
		"bruiser":
			if GameManager.barrack_placed and iron > 10:
				# spawn unit
				pass
		"scout":
			if GameManager.laboratory_placed and iron > 10:
				pass
		"sniper":
			if GameManager.barrack_placed and iron > 10:
				pass
		"warden":
			if GameManager.laboratory_placed and iron > 10:
				pass
		"screecher":
			if GameManager.barrack_placed and iron > 10:
				pass
		_:
			print("Not valid button")

func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		var unit:Unit = body.get_parent()
		if unit.carrying_ore == true: 
			unit.load_ore()
			#Total ore ++++++
			unit.change_state("mining")
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
		
			
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

# called when the HQ is destroyed
func _on_building_destroyed():
	print("Team %s just lost. rip bozo" % team)
	#TODO Endgame logic

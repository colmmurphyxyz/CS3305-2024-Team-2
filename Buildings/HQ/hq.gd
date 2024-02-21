extends Base

var free_spawn = 60.0
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

func _spawn_unit(type: String):
	match type:
		# Set resources required
		"drone":
			if free_spawn <= 0:
				#spawn drone
				pass
			elif iron > 10:
				# buy unit, check unit cost, and iron from game controller
				pass
		"bruiser":
			if barrack_placed and iron > 10:
				# spawn unit
				pass
		"scout":
			print("pressed")
			if laboratory_placed and iron > 10:
				pass
		"sniper":
			if barrack_placed and iron > 10:
				pass
		"warden":
			if laboratory_placed and iron > 10:
				pass
		"marrauder":
			if barrack_placed and iron > 10:
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

extends "res://Buildings/base.gd"
	
var increase_value: int = 0
var increase_timer: Timer

const max_hp = 100.0
var health = 1.0

const max_storage = 250
var stored_resources = 0

var close_mining_units:Array = []

func _ready():
	super._ready()
	increase_timer = Timer.new()
	increase_timer.wait_time = 1.0  # Wait time in seconds
	increase_timer.timeout.connect(_on_increase_timer_timeout)
	add_child(increase_timer)
	increase_timer.start()
	add_to_group("Mines")
	health=100
	is_active=true
	
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		queue_free()
	if not health >= max_hp:
		if in_area.size() > 0:
			health += delta * in_area.size()
			if health >= max_hp:
				is_active = true
				#print("Repair complete!")
			#print("Repairing...", health, "/", max_hp)
		else:
			#print("Repair stopped")
			pass
	
func _on_increase_timer_timeout():
	
	if is_active:
		for unit_body in close_mining_units:
			var unit:Unit = unit_body.get_parent()
			print(unit.get_state())
			if unit.get_state() == "mining" and unit.carrying_ore==false:
				increase_value-=1
				unit.load_ore()
		if stored_resources < max_storage:
			increase_value += 1


		
func _on_unit_collecting():
	#add logit to transfer resources from storage to unit if unit type matches.
	
	pass


func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
			
			
			
			



func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

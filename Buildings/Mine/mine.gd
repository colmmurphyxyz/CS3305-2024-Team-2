extends Base
	
var increase_value: int = 0
var increase_timer: Timer

const max_storage = 250
var stored_resources = 0

#var close_mining_units:Array = []
#@onready var healthbar = $Healthbar
#@export var explosion:PackedScene
func _ready():
	max_hp = 100.0
	health = 1.0
	super._ready()
	is_active=false
	#healthbar.max_value=round(max_hp)
	increase_timer = Timer.new()
	increase_timer.wait_time = 1.0  # Wait time in seconds
	increase_timer.timeout.connect(_on_increase_timer_timeout)
	add_child(increase_timer)
	increase_timer.start()
	add_to_group("Constructions")
	
	
func _process(delta):
	super._process(delta)
	if health >= max_hp:
		add_to_group("Mines")
	#healthbar.value=health
	#if health <= 0:
		#queue_free()
	#if health < max_hp:
		#sprite.modulate=Color.DIM_GRAY
		#if in_area.size() > 0:
			#
			#for body in in_area:
				#var unit:Unit = body.get_parent()
				#if unit.state_name=="building":
						#health += delta
			#if health >= max_hp:
				#is_active = true
				#sprite.modulate=Color(1,1,1)
				#remove_from_group("Constructions")
				#add_to_group("Mines")
				##print("Repair complete!")
			#print("Repairing...", health, "/", max_hp)
		#else:
			##print("Repair stopped")
			#pass
	
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


#func _on_area_2d_body_entered(body):
	#if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		#if body.get_parent().can_mine == true: 
			#close_mining_units.append(body)
			

func damage(damage_amount):
	#sprite2d.material.set("shader_param/active",true)
	health-=damage_amount
	healthbar.value=health
	
	if health <= 0:
		var explosion_node = explosion_scene.instantiate()
		get_parent().add_child(explosion_node)
		explosion_node.global_position = global_position
		@warning_ignore("integer_division")
		explosion_node.scale *= (sprite.texture.get_width() / 400)
		queue_free()

#func _on_area_2d_body_exited(body):
	#close_mining_units.erase(body)

extends Base
	
var increase_value: int = 0
var increase_timer: Timer

const max_storage = 250
var stored_resources = 0

var has_klassium = false # Flagset by buildsystem, if a mine was placed in a 'Klassium' ore deposit

func _ready():
	max_hp = 100.0
	health = 1.0
	super._ready()
	# timer for syncronous ore generation and prevent float values for resources
	is_active=false
	increase_timer = Timer.new()
	increase_timer.wait_time = 1.0 
	increase_timer.timeout.connect(_on_increase_timer_timeout)
	add_child(increase_timer)
	increase_timer.start()
	add_to_group("Constructions")
	
	
func _process(delta):
	super._process(delta)
	if health >= max_hp:
		add_to_group("Mines")
	
func _on_increase_timer_timeout():
	# if active tranfer ore to units to carry and generate stored ore
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


func damage(damage_amount):
	#sprite2d.material.set("shader_param/active",true)
	health-=damage_amount
	healthbar.value=health
	
	if health <= 0:
		var explosion_node = explosion.instantiate()
		get_parent().add_child(explosion_node)
		explosion_node.global_position = global_position
		@warning_ignore("integer_division")
		explosion_node.scale *= (sprite.texture.get_width() / 400)
		queue_free()


extends "res://Buildings/Base/base.gd"

var bullet_scene: PackedScene = preload("res://Bullet/Bullet.tscn")

const reload = 5.0

var current_target: Node = null
var attack_timer_count: float = reload
var fired: bool = false

const max_hp = 100.0
var health = 1.0

func _ready():
	super._ready()
	is_active=true
	set_collision_circle_radius(30.0)
	
func _process(delta):
	super._process(delta)
	repair(delta)
	if is_active:
		attack_timer_count -= delta
		update_target()
		if is_instance_valid(current_target):
			if attack_timer_count <= 0:
				attack_timer_count = reload
				attack()
				fired = false

func update_target():
	if enemy_in_area.size() > 0:
		current_target = enemy_in_area[0]
		#print(current_target)
	else:
		current_target = null
		
	
func attack():
	if not fired:
		fired = true
		attack_timer_count = reload
		var bullet = bullet_scene.instantiate()  # Assuming you have a Bullet scene
		get_parent().add_child(bullet)
		if is_instance_valid(current_target):
			bullet.set_target(current_target)
			bullet.global_position = global_position
			bullet.damage = 10  # Set the appropriate damage value
			bullet.speed = 150  # Set the appropriate speed value
		else:
			bullet.queue_free()
	
	
func repair(delta):
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
			

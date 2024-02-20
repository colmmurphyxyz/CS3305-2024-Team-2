extends Base

@export var sprite_texture_tier_2:Texture2D
@export var sprite_texture_tier_3:Texture2D

var bullet_scene: PackedScene = preload("res://Bullet/Bullet.tscn")

var tier: int = 1

var attack_damage: int
var attack_speed: int
var reload: float
var attack_range: float

var current_target: Node = null
var attack_timer_count: float = reload
var fired: bool = false

func _ready():
	super._ready()
	update_tower_stats()
	set_collision_circle_radius(attack_range)
	
func _process(delta):
	super._process(delta)
	
	#if health <= 0:
		#queue_free()
	#if health < max_hp:
		#if in_area.size() > 0: # bug, if spawned next to units, they need to be move out and back in to repair
			#health += delta * in_area.size()
			#if health >= max_hp: 
				#is_active = true
				##print("Repair complete!")
			##print("Repairing...", health, "/", max_hp)
		#else:
			##print("Repair stopped")
			#pass
			
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
			bullet.damage = attack_damage  # Set the appropriate damage value
			bullet.speed = attack_speed  # Set the appropriate speed value
		else:
			bullet.queue_free()

func update_tower_stats():
# Adjust variables based on the current tier
	match tier:
		1:
			attack_damage = 10
			attack_speed = 200
			reload = 5.0
			attack_range = 30.0
			max_hp = 100.0
			$Sprite2D.texture = sprite_texture
			healthbar.max_value = round(max_hp)
		2:
			attack_damage = 10
			attack_speed = 200
			reload = 5.0
			attack_range = 15.0
			max_hp = 100.0
			sprite.texture = sprite_texture_tier_2
			healthbar.max_value = round(max_hp)
		3:
			attack_damage = 10
			attack_speed = 200
			reload = 5.0
			attack_range = 15.0
			max_hp = 100.0
			healthbar.max_value = round(max_hp)
			#change sprite
# Add more cases for additional tiers

# Function to upgrade the tower
func upgrade():
	if tier < 3:  # Adjust the max tier as needed
		tier += 1
		update_tower_stats()
		print("Tower upgraded to tier:", tier)

# Function to downgrade the tower
func downgrade():
	if tier > 1:  # Adjust the min tier as needed
		tier -= 1
		update_tower_stats()
		print("Tower downgraded to tier:", tier)


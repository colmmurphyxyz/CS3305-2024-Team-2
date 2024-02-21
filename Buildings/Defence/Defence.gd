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
	# If structure was built, start reloading and update target in area
	if is_active:
		attack_timer_count -= delta
		update_target()
		if is_instance_valid(current_target): 
			if attack_timer_count <= 0: # If reloaded shoot at target
				attack_timer_count = reload
				attack()
				fired = false

func update_target():
	if enemy_in_area.size() > 0: # If there are enemies in radius target the one entered earliest
		if is_instance_valid(enemy_in_area[0]):
			current_target = enemy_in_area[0]
		#print(current_target)
	else:
		current_target = null
		
	
func attack():
	# Load a bullet instance and pass current target if still in area
	if not fired:
		fired = true
		attack_timer_count = reload
		var bullet = bullet_scene.instantiate()
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

# Upgrade and downgrade system
func upgrade():
	if tier < 3:
		tier += 1
		update_tower_stats()
		print("Tower upgraded to tier:", tier)

func downgrade():
	if tier > 1:
		tier -= 1
		update_tower_stats()
		print("Tower downgraded to tier:", tier)


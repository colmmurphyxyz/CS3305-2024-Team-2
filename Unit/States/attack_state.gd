extends State
class_name AttackingState
var attack_timer_count:float;

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_timer_count=10.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var current_target = persistent_state.current_target
	print(persistent_state.units_within_attack_range)
	#if target is null or not found in attack range switch to idle
	if current_target == null or current_target not in persistent_state.units_within_attack_range:
		persistent_state.change_state("idle")

	attack_timer_count=attack_timer_count-persistent_state.attack_speed
	print(attack_timer_count)
	#Attack on timer end
	if attack_timer_count <=0:
		attack_timer_count=10
		var bullet = persistent_state.bullet.instantiate()
		print(attack_timer_count)
		get_parent().owner.add_child(bullet)
		if is_instance_valid(current_target):
			bullet.set_target(current_target)
			bullet.global_position=persistent_state.body.global_position
			bullet.damage=persistent_state.attack_damage
			bullet.speed=persistent_state.bullet_speed
		else:
			queue_free()
	
	
	
	
	

extends State
class_name AttackingState
var attack_timer_count=10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_target = persistent_state.current_target
	#if target is null or not found in attack range switch to idle
	if current_target == null or current_target not in persistent_state.units_within_attack_range:
		persistent_state.change_state("idle")
	
	attack_timer_count-=persistent_state.attack_speed
	#Attack on timer end
	if attack_timer_count <=0:
		attack_timer_count=10
		var bullet = persistent_state.bullet.instantiate()
		get_parent().owner.add_child(bullet)
		if is_instance_valid(current_target):
			bullet.set_target(current_target)
			bullet.global_position=persistent_state.body.global_position
		else:
			queue_free()
	
	
	
	
	

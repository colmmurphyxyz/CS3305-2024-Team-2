extends State

class_name IdleState

func _ready():
	#animated_sprite.play("idle")
	persistent_state.sort_enemies_in_attack_area_by_distance(persistent_state.units_within_attack_range)
	persistent_state.body.nav_agent.target_position=persistent_state.body.global_position
func _process(delta):
	var enemy_list = persistent_state.units_within_attack_range
	#Scan a raycast to list of enemies near target, if it hits a wall, dont target that
	if persistent_state.is_chasing != null:
		persistent_state.change_state("moving")
	for enemy in enemy_list:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(persistent_state.body.global_position, enemy.global_position,12)
		query.exclude = [self,enemy]
		var result = space_state.intersect_ray(query)
		if result.size() == 0:
			persistent_state.current_target=enemy
			if persistent_state.melee==true:
				persistent_state.is_chasing=enemy
				persistent_state.change_state("moving")
			else:
				persistent_state.change_state("attacking")
			

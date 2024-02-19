extends State

class_name IdleState

func _ready():
	persistent_state.target_building = null
	persistent_state.sprite2d.play("idle")

	persistent_state.sort_enemies_in_attack_area_by_distance(persistent_state.units_within_attack_range)
	persistent_state.body.nav_agent.target_position=persistent_state.body.global_position

func _process(delta):
	if !is_multiplayer_authority():
		#print("not processing idle state for %s. owned by %d and i am %d" % \
				#[get_parent().name, get_multiplayer_authority(), multiplayer.get_unique_id()])
		return
	var enemy_list = persistent_state.units_within_attack_range
	#Scan a raycast to list of enemies near target, if it hits a wall, dont target that
	if persistent_state.is_chasing != null:
		persistent_state.change_state("moving")
	for enemy in enemy_list:
		persistent_state.current_target=enemy
		if persistent_state.melee==true:
			persistent_state.is_chasing=enemy
			persistent_state.change_state("moving")
		else:
			persistent_state.change_state("attacking")
			

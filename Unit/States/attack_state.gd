extends State
class_name AttackingState
var attack_timer_count:float;
var fired=false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	attack_timer_count=10.0
	persistent_state.sprite2d.play("attack")
	persistent_state.sprite2d.pause()
	multiplayer.allow_object_decoding = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#A BIT MESSY BUT HOW IT WORKS
	#When Attack timer count hits 0, play attacking animation, when attacking animation is
	#on attack frame, fire attack, when animation finishes, set attack timer back and pause animation
	
	var current_target = persistent_state.current_target
	attack_timer_count=attack_timer_count-persistent_state.attack_speed

	#if target is null or not found in attack range switch to idle
	if fired == false and (current_target == null or current_target not in persistent_state.units_within_attack_range):
		persistent_state.change_state("idle")
	if is_instance_valid(current_target):
		persistent_state.sprite2d.rotation = persistent_state.body.global_position.angle_to_point(current_target.global_position)+ 1.5708*3


	#Attack on timer end
	if attack_timer_count <=0 and persistent_state.sprite2d.animation == "attack":
		persistent_state.sprite2d.play("attack")

	if persistent_state.sprite2d.frame == persistent_state.attack_frame and fired==false:
		fired=true
		spawn_bullet.rpc_id(1, \
				multiplayer.get_unique_id(),\
				current_target.get_parent().name,\
				get_parent().position,\
				persistent_state.attack_damage,\
				persistent_state.bullet_speed)
		#var bullet = persistent_state.bullet.instantiate()
		##get_parent().owner.add_child(bullet)
		#get_parent().add_sibling(bullet, true)
		#if is_instance_valid(current_target):
			#bullet.set_target(current_target)
			#bullet.global_position=persistent_state.body.global_position
			#bullet.damage=persistent_state.attack_damage
			#bullet.speed=persistent_state.bullet_speed
		#else:
			##????? bullet.queu?
			#queue_free()

	if persistent_state.sprite2d.sprite_frames.get_frame_count("attack")-1 == persistent_state.sprite2d.frame:

		attack_timer_count=10
		persistent_state.sprite2d.frame=0
		persistent_state.sprite2d.pause()
		fired=false
	
@rpc("any_peer", "call_local")
func spawn_bullet(called_by: int, target_name: String, spawn_pos: Vector2, damage, speed):
	var new_bullet = persistent_state.bullet.instantiate()
	new_bullet.target_brain_name = target_name
	new_bullet.damage = damage
	new_bullet.speed = 50
	new_bullet.position = spawn_pos
	get_parent().add_sibling(new_bullet, true)
	set_bullet_authority.rpc(new_bullet.name, called_by)
	
@rpc("authority", "call_local")
func set_bullet_authority(node_name: String, auth: int):
	get_parent().get_parent().get_node(node_name).get_node("MultiplayerSynchronizer")\
			.set_multiplayer_authority(auth)

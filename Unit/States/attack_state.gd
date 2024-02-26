extends State
class_name AttackingState

var attack_timer_count: float;
var fired = false

# Called when the node enters the scene tree for the first time.
func _ready():

	attack_timer_count=10.0
	persistent_state.sprite2d.play("attack")
	persistent_state.sprite2d.pause()


func _process(_delta: float):
	if !is_multiplayer_authority():
		#print("not processing attack state for %s. owned by %d\t\t and i am %d\t\t" % \
				#[get_parent().name, get_multiplayer_authority(), multiplayer.get_unique_id()])
		return
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
	if get_parent().name.begins_with("FusionScreecher") and persistent_state.sprite2d.frame==2 and persistent_state.sprite2d.animation == "attack":

		if is_instance_valid( $"../ChargeSound"):
			if $"../ChargeSound".playing == false:
				$"../ChargeSound".play()
	#Attack on timer end
	if attack_timer_count <=0 and persistent_state.sprite2d.animation == "attack":
		persistent_state.sprite2d.play("attack")

	if persistent_state.sprite2d.frame == persistent_state.attack_frame and fired==false:
		persistent_state.play_attack_sound.rpc()
		fired=true
		var bullet_target
		if current_target in get_tree().get_nodes_in_group("Buildings"):
			bullet_target=current_target.name
		else:
			bullet_target=current_target.get_parent().name
		# don't shoot if target is invalid (doesn't exist)
		if is_instance_valid(current_target):
			get_parent().spawn_bullet.rpc_id(1, \
					multiplayer.get_unique_id(),\
					bullet_target,\
					$"../Body".global_position,\
					persistent_state.attack_damage,\
					persistent_state.bullet_speed)

	if persistent_state.sprite2d.sprite_frames.get_frame_count("attack")-1 == persistent_state.sprite2d.frame:
		attack_timer_count=10
		persistent_state.sprite2d.frame=0
		persistent_state.sprite2d.pause()
		fired=false
	

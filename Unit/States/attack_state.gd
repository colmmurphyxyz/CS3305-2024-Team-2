extends State
class_name AttackingState
var attack_timer_count:float;
var fired=false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	attack_timer_count=10.0
	persistent_state.sprite2d.play("attack")
	persistent_state.sprite2d.pause()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#A BIT MESSY BUT HOW IT WORKS
	#When Attack timer count hits 0, play attacking animation, when attacking animation is
	#on attack frame, fire attack, when animation finishes, set attack timer back and pause animation
	
	var current_target = persistent_state.current_target
	attack_timer_count=attack_timer_count-persistent_state.attack_speed

	#if target is null or not found in attack range switch to idle
	if current_target == null or current_target not in persistent_state.units_within_attack_range:
		persistent_state.change_state("idle")
	if is_instance_valid(current_target):
		persistent_state.sprite2d.rotation = persistent_state.body.global_position.angle_to_point(current_target.global_position)+ 1.5708*3


	#Attack on timer end
	if attack_timer_count <=0 and persistent_state.sprite2d.animation == "attack":

		persistent_state.sprite2d.play("attack")

	if persistent_state.sprite2d.frame == persistent_state.attack_frame and fired==false:
		fired=true
		var bullet = persistent_state.bullet.instantiate()
		get_parent().owner.add_child(bullet)
		if is_instance_valid(current_target):
			bullet.set_target(current_target)
			bullet.global_position=persistent_state.body.global_position
			bullet.damage=persistent_state.attack_damage
			bullet.speed=persistent_state.bullet_speed

		else:
			#????? bullet.queu?
			queue_free()

	if persistent_state.sprite2d.sprite_frames.get_frame_count("attack")-1 == persistent_state.sprite2d.frame:
		print("done")
		attack_timer_count=10
		persistent_state.sprite2d.frame=0
		persistent_state.sprite2d.pause()
		fired=false
	
	
	
	
	

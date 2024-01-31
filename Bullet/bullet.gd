extends CharacterBody2D
var target_unit:CharacterBody2D=null
var target_brain:Node2D=null
var damage=1
func set_target(unit:CharacterBody2D):
	target_unit=unit
	target_brain=unit.get_parent()
func _physics_process(delta):
	if is_instance_valid(target_unit):
		var direction = (target_unit.global_position - global_position).normalized()
		global_position += direction * 300 * delta
		if global_position.distance_to(target_unit.global_position) < 20:  
			target_unit.get_parent().damage(damage)
			queue_free()
		move_and_slide()
	else:
		queue_free()

extends CharacterBody2D
var target_unit=null
var target_brain:Node2D=null
var damage=1
var speed=300
func set_target(unit):
	target_unit=unit
	if target_unit in get_tree().get_nodes_in_group("Buildings"):
		target_brain=unit
	else:
		target_brain=unit.get_parent()
func _physics_process(delta):
	if is_instance_valid(target_unit):
		var direction = (target_unit.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		if global_position.distance_to(target_unit.global_position) < 20:  
			target_unit.get_parent().damage(damage)
			
			var bullet_hit: PackedScene = load("res://Unit/BaseUnit/BulletHit.tscn")
			var bullet_unit = bullet_hit.instantiate()
			get_parent().add_child(bullet_unit)
			bullet_unit.sprite.rotation=direction.angle()
			bullet_unit.global_position = global_position
			var size = round(damage/5)
			if size < 1:
				size=1 
			bullet_unit.scale*= size
			
			queue_free()
		move_and_slide()
	else:
		queue_free()

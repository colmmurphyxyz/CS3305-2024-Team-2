extends CharacterBody2D

# Physics processing for Bullets is done by the server only

@export_group("Targetting")
@export var target_brain_name: String
var target_unit = null
var target_brain = null

@export_group("Physics and damage")
@export var damage: int = 1
@export var speed: int = 300

func _ready():
	set_target_by_name(target_brain_name)

func set_target(unit):
	target_unit=unit
	if target_unit in get_tree().get_nodes_in_group("Buildings"):
		target_brain=unit
	else:
		#print(get_tree().get_nodes_in_group("Buildings"))
		target_brain=unit.get_parent()
		
func _physics_process(delta):
	if !get_node("MultiplayerSynchronizer").is_multiplayer_authority():
		return
	if is_instance_valid(target_unit):
		var direction: Vector2 = (target_unit.global_position - global_position).normalized()
		$Sprite2D.rotation = atan(direction.y / direction.x)
		if direction.x > 0:
			$Sprite2D.rotation += PI
		position += direction * speed * delta

		if global_position.distance_to(target_unit.global_position) < 20:
			# do damage calculation on the unit's owner's machinem to ensure
			# updated health values are replicated
			# and to avoid race conditions etc...
			var damage_recipient = target_unit \
					if target_brain.is_in_group("Buildings") \
					else target_unit.get_parent()
			damage_recipient.damage.rpc_id(
				target_brain.get_node("MultiplayerSynchronizer").get_multiplayer_authority(),
				damage
				)
			spawn_bullet_hit_scene()
			queue_free()
		move_and_slide()
	else:
		queue_free()
		
func set_target_by_name(n: String):
	var target_unit: Node2D = get_parent().get_node_or_null(n)
	# if target suddenly doesn't exist, remove the bullet
	# im assuming this would happen if the target dies
	#if target_unit == null or !is_instance_valid(target_unit):
		#print("couldn't find target (did it die?)")
		#queue_free()
		#return
	if !is_instance_valid(target_unit):
		queue_free()
	elif target_unit.is_in_group("Buildings"):
		set_target(target_unit)
	else:
		set_target(target_unit.get_node("Body"))
	
func spawn_bullet_hit_scene():
	var bullet_unit: StaticBody2D = \
			preload("res://Unit/BaseUnit/BulletHit.tscn").instantiate()
	bullet_unit.position = position
	var size: int = round(damage / 5)
	if size < 1:
		size = 1 
	bullet_unit.scale *= size
	add_sibling(bullet_unit, true)

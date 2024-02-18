extends CharacterBody2D
# Physics processing for Bullets is done by the server only

@export_group("Targetting")
@export var target_brain_name: String
@export var target_unit:CharacterBody2D=null
@export var target_brain:Node2D=null

@export_group("Physics and damage")
@export var damage: int = 1
@export var speed: int = 300

func _ready():
	set_target_by_name(target_brain_name)
	
func _physics_process(delta: float):
	if !get_node("MultiplayerSynchronizer").is_multiplayer_authority():
		return
	if is_instance_valid(target_unit):
		var direction: Vector2 = (target_unit.global_position - global_position).normalized()
		position += direction * speed * delta
		
		if global_position.distance_to(target_unit.global_position) < 20:
			# do damage calculation on the unit's owner's machinem to ensure
			# updated health values are replicated
			# and to avoid race conditions etc...
			target_unit.get_parent().damage.rpc_id(
				target_brain.get_node("MultiplayerSynchronizer").get_multiplayer_authority(),
				damage
				)
			spawn_bullet_hit_scene.rpc()
			
			queue_free()
		move_and_slide()
	else:
		queue_free()
		
func set_target(unit:CharacterBody2D):
	target_unit=unit
	target_brain=unit.get_parent()
		
func set_target_by_name(n: String):
	var target_unit: Node2D = get_parent().get_node_or_null(n)
	if target_unit != null:
		set_target(target_unit.get_node("Body"))
	
@rpc("any_peer", "call_local")
func spawn_bullet_hit_scene():
	var bullet_unit: StaticBody2D = \
			preload("res://Unit/BaseUnit/BulletHit.tscn").instantiate()
	bullet_unit.position = position
	var size: int = round(damage / 5)
	if size < 1:
		size = 1 
	bullet_unit.scale *= size
	add_sibling(bullet_unit, true)

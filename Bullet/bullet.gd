extends CharacterBody2D
@export var target_brain_name: String
@export var target_unit:CharacterBody2D=null
@export var target_brain:Node2D=null
@export var damage=1
@export var speed=300

func _ready():
	set_target_by_name(target_brain_name)

func set_target(unit:CharacterBody2D):
	target_unit=unit
	target_brain=unit.get_parent()
	
func _physics_process(delta):
	if !get_node("MultiplayerSynchronizer").is_multiplayer_authority():
		return
	if is_instance_valid(target_unit):
		var direction = (target_unit.global_position - global_position).normalized()
		position += direction * speed * delta
		
		if global_position.distance_to(target_unit.global_position) < 20:
			print("you hit my battleship")
			target_unit.get_parent().damage(damage)
			
			var bullet_hit: PackedScene = load("res://Unit/BaseUnit/BulletHit.tscn")
			var bullet_unit = bullet_hit.instantiate()
			get_parent().add_child(bullet_unit)
			bullet_unit.sprite.rotation=direction.angle()
			bullet_unit.position = position
			var size = round(damage/5)
			if size < 1:
				size=1 
			bullet_unit.scale*= size
			
			queue_free()
		move_and_slide()
	else:
		queue_free()
		
func set_target_by_name(n: String):
	var target_body: CharacterBody2D = get_parent().get_node(n).get_node("Body")
	set_target(target_body)

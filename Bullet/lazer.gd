extends Node2D

@export var team: String
@export var damaging: bool = false
@export var target_brain_name: String = ""

var damage: int = 80
# speed is never used for the lazer, 
# but the property is needed for compatibility with regular bullet code
var speed: int
var cast_point: Vector2 = Vector2.ZERO

@onready var tween = get_tree().create_tween()
@onready var ray1 = $RayCast2D
@onready var ray2 = $RayCast2D2
@onready var ray3 = $RayCast2D3
@onready var ray7 = $RayCast2D7
@onready var ray5 = $RayCast2D5
@onready var ray6 = $RayCast2D6
@onready var ray_array = [ray1,ray2,ray3,ray5,ray6,ray7]
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var target = get_parent().get_node_or_null(target_brain_name)
	if target != null:
		cast_point = target.global_position if target.is_in_group("Buildings") \
				else target.body.global_position
		#cast_point=target.body.global_position
		team = target.get_team()
		print(cast_point)
		$Sound.play()

	$Line2D.width=0
	var direction = global_position.direction_to(cast_point)
	$Line2D.points[1] = to_local(global_position+direction*5000)

			
	tween.tween_property($Line2D,"width",100,1).set_trans(Tween.TRANS_ELASTIC)


func _process(_delta: float):
	if !$MultiplayerSynchronizer.is_multiplayer_authority():
		return
	if $Line2D.width > 50:
		damaging=true
	var direction = global_position.direction_to(cast_point)
	for i:RayCast2D in ray_array:
		i.target_position = to_local(global_position+direction*5000)
		if i.is_colliding():
			if (i.get_collider().get_parent() in get_tree().get_nodes_in_group("Units")\
					or i.get_collider().is_in_group("Buildings")) and damaging==true:
				var collider: PhysicsBody2D = i.get_collider()
				var target_brain = collider if collider.is_in_group("Buildings") else collider.get_parent()
				if target_brain.get_team() == team:
					target_brain.damage.rpc_id(
						target_brain.get_node("MultiplayerSynchronizer").get_multiplayer_authority(),
						damage)
			else:
				if i == ray6:
					$Line2D.points[1] = to_local(i.get_collision_point())

				
	if tween.is_running() !=true:
		$Line2D.width+=(randf_range(-12,5))



func _on_timer_timeout():
	queue_free()

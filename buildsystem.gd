extends Node2D

## Placed buildings will be children of this node.
## Unplaced children will be children of the node this script is attached to.
@export var building_root: Node

var spawned_object = null
var placement_allowed = false
var deposit = false
var mine = false

func _process(_delta: float):
	if Input.is_action_just_pressed("right_click"):
		cancel_placement()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null && placement_allowed:
			print("placing(?)")
			if mine && deposit == false:
				print("No deposit found nearby")
			elif spawned_object.stop_following_mouse() == true: # if placed
				spawned_object.health= spawned_object.max_hp
				spawned_object.is_active = true
				spawned_object.sprite.modulate=Color(1,1,1)
				spawned_object.remove_from_group("Constructions")
				spawned_object.is_placed = true
				spawned_object = null
				mine = false
				
func _ready():
	pass

func spawn_object(resource):
	spawned_object = resource.instantiate()
	building_root.add_child(spawned_object, true)
	
func _button_press_select(building_name: String):
	cancel_placement()
	match building_name:
		"mine":
			mine = true
			spawn_object(preload("res://Buildings/Mine/mine.tscn"))
		"hq":
			spawn_object(preload("res://Buildings/HQ/hq.tscn"))
		"defence":
			spawn_object(preload("res://Buildings/Defence/Defence.tscn"))
		"barracks":
			spawn_object(preload("res://Buildings/Barracks/barracks.tscn"))
		"laboratory":
			spawn_object(preload("res://Buildings/Lab/Laboratory.tscn"))
		"fusion":
			spawn_object(preload("res://Buildings/Fusion/FusionLab.tscn"))
		_:
			print("Not valid structure")
	pass
	
func _button_entered():
	placement_allowed = false
	
func _button_exited():
	placement_allowed = true
	
func _deposit_enter():
	deposit = true
	
func _deposit_exit():
	deposit = false

func move_object():
	# add move after placement
	pass
	
func move_node(node: Node, new_parent: Node):
	node.get_parent().remove_child(node) # Get node's parent and remove node from it    
	new_parent.add_child(node, true) # Add node to new parent as a child 

func cancel_placement():
	if spawned_object != null:
		spawned_object.queue_free()
		spawned_object = null
		mine = false

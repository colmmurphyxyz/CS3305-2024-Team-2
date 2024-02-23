extends Node2D

var spawned_object = null
var placement_allowed = false
var deposit = false
var mine = false
var unobtainium = false

func _process(_delta: float):
	if Input.is_action_just_pressed("right_click"): # click at any time to cancel placing an object
		cancel_placement()

	if Input.is_action_just_pressed("left_click"): # Place object at current mouse position
		placing()
				
func _ready():
	pass

func spawn_object(resource):
	spawned_object = resource.instantiate()
	add_child(spawned_object, true)
	
func placing():
	if spawned_object != null && placement_allowed:
			if mine && deposit == false:
				print("No deposit found nearby")
			elif spawned_object.stop_following_mouse() == true: # if placed
				if mine:
					spawned_object.has_unobtainium = unobtainium
				spawned_object = null
				mine = false
	
func _button_press_select(building_name: String): # Arg passed by a signal for structure type
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
	
# Prevent placing buildings on UI
func _button_entered():
	placement_allowed = false
	
func _button_exited():
	placement_allowed = true
	
# Check if a mine's placement is attempted in an ore area
func _deposit_enter():
	deposit = true
	
func _deposit_exit():
	deposit = false
	
# Special ore areas
func _unobtainium_area():
	unobtainium = true
	
func _not_unobtainium_area():
	unobtainium = false
	
# Move object after placement !!! Action to be configured
func _move_object(object): # 
	spawned_object = object

func cancel_placement():
	if spawned_object != null:
		spawned_object.queue_free()
		spawned_object = null
		mine = false

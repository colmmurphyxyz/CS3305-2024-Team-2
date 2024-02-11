extends Node2D

var spawned_object = null
var placement_allowed = false
var deposit = false
var mine = false

func _process(delta):
	if Input.is_action_just_pressed("right_click"):
		cancel_placement()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null && placement_allowed:
			if mine && deposit == false:
				print("No deposit found nearby")
			elif spawned_object.stop_following_mouse() == true: # if placed
				spawned_object = null
				mine = false
				
func _ready():
	pass

func spawn_object(resource):
	spawned_object = resource.instantiate()
	add_child(spawned_object)
	
func _button_press_select(name: String):
	cancel_placement()
	match name:
		"mine":
			mine = true
			spawn_object(preload("res://Buildings/mine.tscn"))
		"hq":
			spawn_object(preload("res://Buildings/hq.tscn"))
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

func cancel_placement():
	if spawned_object != null:
		spawned_object.queue_free()
		spawned_object = null
		mine = false

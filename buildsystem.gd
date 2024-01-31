extends Node2D

var spawned_object = null

func _process(delta):
	#if Input.is_action_pressed("placement"): # currently P
		#if spawned_object == null:
			#spawn_object()
		#else:
			#move_object()
	if Input.is_action_just_pressed("right_click"):
		cancel_placement()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null:
			if spawned_object.stop_following_mouse() == true: # if placed
				spawned_object = null
				
func _ready():
	pass

func spawn_object(resource):
	spawned_object = resource.instantiate()
	add_child(spawned_object)
	
func _button_press_select(name: String):
	match name:
		"mine":
			spawn_object(preload("res://Buildings/mine.tscn"))
		"hq":
			spawn_object(preload("res://Buildings/base.tscn"))
		_:
			print("Not valid structure")
	pass

func move_object():
	# add move after placement
	pass

func cancel_placement():
	if spawned_object != null:
		spawned_object.queue_free()
		spawned_object = null

extends Node2D

var spawned_object = null

func _process(delta):
	if Input.is_action_pressed("placement"): # currently P
		if spawned_object == null:
			spawn_object()
		else:
			move_object()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null:
			if spawned_object.stop_following_mouse() == true: # if placed
				spawned_object = null

func spawn_object():
	var object_scene = preload("res://Buildings/base.tscn")
	spawned_object = object_scene.instantiate()
	add_child(spawned_object)

func move_object():
	# add move after placement
	pass

extends Node2D

var spawned_object = null

func _process(delta):
	if Input.is_action_pressed("placement"):
		if spawned_object == null:
			spawn_object()
		else:
			move_object()

	if Input.is_action_just_pressed("left_click"):
		if spawned_object != null:
			if spawned_object.stop_following_mouse() == true:
				spawned_object = null

func spawn_object():
	# Load the PackedScene
	var object_scene = preload("res://Buildings/base.tscn")

	# Create an instance of the object scene
	spawned_object = object_scene.instantiate()
	
	# Add the instance as a child of the Node2D
	add_child(spawned_object)
	spawned_object.collision_layer = 0

func move_object():
	# You can add logic for moving the object here if needed
	pass

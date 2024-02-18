extends "res://Buildings/base.gd"

var context_menu_scene = preload("res://UI/scenes/structure_interaction.tscn")
var context_menu_instance

var  timer: Timer

var free_spawn = 60

func _ready():
	super._ready()
	max_hp = 100.0
	health = 100.0
	is_active = true
	timer = Timer.new()
	timer.wait_time = 1.0  # Wait time in seconds
	timer.timeout.connect(_on_timer)
	add_child(timer)
	timer.start()
	remove_from_group("Constructions")
	
func _process(delta):
	super._process(delta)
	#if health <= 0:
		##loss senario
		#pass
	#if health < max_hp:
		#if in_area.size() > 0:
			#health += delta * in_area.size()
			#if health >= max_hp:
				#is_active = true
				##print("Repair complete!")
			##print("Repairing...", health, "/", max_hp)
		#else:
			##print("Repair stopped")
			#pass

func _on_timer():
	if free_spawn > 0:
		free_spawn -= 1


func _input(event):
	if event.is_action_pressed("right_click"):
		if get_global_mouse_position().distance_to(global_transform.origin) < 50:
			on_right_click()

func on_right_click():
	show_context_menu()

func show_context_menu():
	# Check if the context menu is not already visible
	if not context_menu_instance:
		# Instantiate the context menu scene
		context_menu_instance = context_menu_scene.instantiate()
		
		# Set the position of the context menu next to the StaticBody2D
		var position = get_viewport().get_camera_2d().get_global_mouse_position()
		
		position.x += 10  # Offset to the right
		context_menu_instance.global_position = position
		
		# Add the context menu as a child of the current scene
		add_child(context_menu_instance)
		
		# Connect the context menu buttons to their respective functions
		connect_context_menu_buttons()
		context_menu_instance.scale = Vector2(0.5, 0.5)
		# Connect a signal to hide the context menu when a button is pressed
		if context_menu_instance.has_node("Spawn"):  # Replace with the actual name of your button node
			var button = context_menu_instance.get_node("Spawn")
			button.pressed.connect(_on_context_menu_button_pressed)

func connect_context_menu_buttons():
	# Connect each button's "pressed" signal to a function
	for button in context_menu_instance.get_children():
		if button is Button:
			button.presses.connect(_on_context_menu_button_pressed)

func _on_context_menu_button_pressed(button_text):
	# Handle the button press
	print("Button pressed:", button_text)
	
	# Remove the context menu from the scene
	context_menu_instance.queue_free()
	context_menu_instance = null


func _on_area_2d_body_entered(body):
	if body.get_parent() in get_tree().get_nodes_in_group("Units"):
		var unit:Unit = body.get_parent()
		if unit.carrying_ore == true: 
			unit.load_ore()
			#Total ore ++++++
			unit.change_state("mining")
		
			
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

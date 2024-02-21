extends Base

var context_menu_scene = preload("res://UI/scenes/structure_interaction.tscn")
var context_menu_instance

var free_spawn = 60.0

var control = null

func _ready():
	super._ready()
	max_hp = 100.0
	health = max_hp / 2
	is_active = false
	control = get_node("Control")
	control.hide()
	
func _process(delta):
	super._process(delta)
	if free_spawn > 0:
		free_spawn -= delta


func _input(event):
	if event.is_action_pressed("right_click"):
		if get_global_mouse_position().distance_to(global_transform.origin) < 50:
			control.show()
		else:
			control.hide()
	pass

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
		if body.get_parent().can_mine == true: 
			close_mining_units.append(body)
		
			
func _on_area_2d_body_exited(body):
	close_mining_units.erase(body)

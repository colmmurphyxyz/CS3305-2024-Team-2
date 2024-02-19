extends Control


#For now 
var in_use:bool = false
var bus_index = AudioServer.get_bus_index("SFX_master")
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_mute(bus_index, true)
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(100))
	$Panel/value.text = "%d%%" % 10
	$Panel.process_mode = Node.PROCESS_MODE_DISABLED
	visible=false
	$Panel/HSlider.max_value=10
	$Panel/HSlider.value=10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("esc"):
		if in_use == true: 
			visible = false
			$Panel.process_mode = Node.PROCESS_MODE_DISABLED
			in_use=false
		else:
			in_use=true
			visible = true
			$Panel.process_mode = Node.PROCESS_MODE_ALWAYS

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index,value)
	$Panel/value.text = "%d%%" % (value*10)
	pass # Replace with function body.

func set_bus_volume(bus_name:String, value:float):
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value/10000))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
	


func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(bus_index, toggled_on)


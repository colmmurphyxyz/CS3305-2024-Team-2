extends Control

@onready var unit_box: Panel = $info_box/UnitInfo
@onready var iron_label: Label = $info_box/iron/iron_label

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Working")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update iron value
	iron_label.text = str(GameManager.iron)  # Update the label text

func _on_selection_system_export_units_to_ui(unit_brains_array):
	var max_columns: int = 5
	var max_rows: int = 3
	var gap: int = 10  # Adjust this value to change the gap between sprites

	for n in unit_box.get_children():
		n.queue_free()

	var count: int = 0
	for i: Unit in unit_brains_array:
		var column: int = count % max_columns
		var row: int = count / max_columns  # Use / for integer division

		var unit_icon: TextureRect = TextureRect.new()
		unit_box.add_child(unit_icon)
		var unit_texture = i.sprite2d.sprite_frames.get_frame_texture("idle", 1)
		unit_icon.texture = unit_texture
		
		var health_bar: TextureRect = TextureRect.new()
		unit_icon.add_child(health_bar)
		var healthbar_texture = i.healthbar.sprite_frames.get_frame_texture("idle", 0)
		health_bar.texture = healthbar_texture

		var x_position: int = column * (unit_texture.get_width() + gap)
		var y_position: int = row * (unit_texture.get_height() + gap)
		unit_icon.position.x = x_position
		unit_icon.position.y = y_position

		count += 1
		if count >= max_columns * max_rows:
			break  # Limit the number of displayed units

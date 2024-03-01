extends Control

@onready var unit_box: Panel = $info_box/UnitInfo
@onready var iron_label = $info_box/iron/iron_label
@onready var grid = $info_box/UnitInfo/ItemList
var iron: int = 0
var iron_timer: float = 0.0
var iron_increment_interval: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Working")
	grid.add_item("hehehehehehehhehe")
	grid.add_item("fffffsdfd")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update iron value every 10 seconds
	iron_timer += delta
	if iron_timer >= iron_increment_interval:
		iron += 1
		iron_timer = 0.0
		iron_label.text = str(iron)  # Update the label text
		print("Iron value:", iron)

func _on_selection_system_export_units_to_ui(unit_brains_array):
	var max_columns: int = 5
	var max_rows: int = 3
	var gap: int = 10
	grid.clear()
	var count: int = 0
	for i: Unit in unit_brains_array:
	
		var unit_icon: Sprite2D = Sprite2D.new()
		var unit_texture:AtlasTexture = i.sprite2d.sprite_frames.get_frame_texture("idle", 1)
		if unit_texture.get_width() > 32:
			unit_icon.scale/=2
		unit_icon.texture = unit_texture
		print(unit_icon)
		var hp:int = i.hp
		grid.add_item(str(i.hp)+"/"+str(i.healthbar.max_value),unit_texture)
		#var health_bar: TextureRect = TextureRect.new()
		#unit_icon.add_child(health_bar)
		#var unit_healthbar:TextureProgressBar = i.healthbar
		#var healthbar_texture = unit_healthbar.u
		#health_bar.texture = healthbar_texture

		#var x_position: int = column * (unit_texture.get_width() + gap)
		#var y_position: int = row * (unit_texture.get_height() + gap)
		#unit_icon.position.x = x_position
		#unit_icon.position.y = y_position
#
		#count += 1
		#if count >= max_columns * max_rows:
			#break  # Limit the number of displayed units

	pass  # Replace with function body.

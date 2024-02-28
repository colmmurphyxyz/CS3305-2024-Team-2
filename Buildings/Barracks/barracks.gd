extends Base

func _ready():
	max_hp = 500.0
	super._ready()
	add_to_group("Constructions")
	GameManager.barrack_placed = true
	
	
func _process(delta):
	super._process(delta)



func _on_building_destroyed():
	GameManager.barrack_placed = false

extends Base

func _ready():
	max_hp = 250.0
	super._ready()
	add_to_group("Constructions")
	GameManager.laboratory_placed = true
	
	
func _process(delta):
	super._process(delta)


func _on_building_destroyed():
	GameManager.laboratory_placed = false

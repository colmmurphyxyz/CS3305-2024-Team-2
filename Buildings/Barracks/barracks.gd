extends Base

func _ready():
	max_hp = 250.0
	super._ready()
	add_to_group("Constructions")
	GameManager.barrack_placed = true
	
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		GameManager.barrack_placed = false

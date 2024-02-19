extends "res://Buildings/base.gd"

func _ready():
	max_hp = 250.0
	super._ready()
	add_to_group("Constructions")
	barrack_placed = true
	
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		barrack_placed = false

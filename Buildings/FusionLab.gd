extends "res://Buildings/base.gd"

func _ready():
	max_hp = 250.0
	super._ready()
	add_to_group("Constructions")
	fusion_lab_placed = true
	
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		fusion_lab_placed = false

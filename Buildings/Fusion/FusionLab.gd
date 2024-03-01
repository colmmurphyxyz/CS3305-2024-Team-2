extends Base

func _ready():
	max_hp = 500.0
	super._ready()
	add_to_group("Constructions")
	GameManager.fusion_lab_placed = true
	
	
func _process(delta):
	super._process(delta)
	if team !=GameManager.team:
		$Sprite2D.material.set("shader_parameter/team2",true)
func _on_building_destroyed():
	GameManager.fusion_lab_placed = false

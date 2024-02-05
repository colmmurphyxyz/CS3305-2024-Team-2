extends "res://Buildings/base.gd"

@onready var EnemyNode : Area2D = get_node()
# Called when the node enters the scene tree for the first time.
func _ready():
	EnemyNode.body_entered.connect(OnBodyEntered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

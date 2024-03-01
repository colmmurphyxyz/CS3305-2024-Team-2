extends Node2D

@onready var low:AudioStreamPlayer = $low
@onready var mid:AudioStreamPlayer = $mid
@onready var high:AudioStreamPlayer = $high
var playing_db:float = -19.0
# Called when the node enters the scene tree for the first time.
func _ready():
	low.volume_db = playing_db
	mid.volume_db=-60.0
	high.volume_db=-60.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.barrack_placed:
		low.volume_db = -60
		mid.volume_db = playing_db -1
	
	if GameManager.fusion_lab_placed:
		mid.volume_db = -60
		high.volume_db = playing_db -2

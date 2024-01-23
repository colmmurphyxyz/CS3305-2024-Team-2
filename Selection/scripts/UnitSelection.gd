extends Node

var selected = false
var target = Vector2.ZERO
var velocity = Vector2.ZERO
var speed = 60
var target_max = 1


func _ready():
	print("tets")

func move_to(tar):
	target=tar
	
func select():
	selected = true
	$Selected.visible = true

func deselect():
	selected=false
	$Selected.visible=false

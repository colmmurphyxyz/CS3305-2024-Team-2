extends Node

var Host: Dictionary = {
	"name": "hostgamer",
	"id": 1,
}
var Client: Dictionary = {
	"name": "clientgamer",
	"id": 3927,
}
## client's team, either 1 or 2
var team: String

# resources
var iron: int = 0
var unobtainium: int = 0

var barrack_placed: bool = false
var laboratory_placed: bool = false
var fusion_lab_placed: bool = false

func _ready():
	pass
	
func _process(_delta: float):
	pass

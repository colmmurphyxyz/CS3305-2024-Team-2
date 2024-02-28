extends Node

const TEAM_1_HQ_POSITION: Vector2 = Vector2(500, 1250)
const TEAM_2_HQ_POSITION: Vector2 = Vector2(1800, 250)
# reference to the player's HQ, will be set in game scene _ready
var player_hq: StaticBody2D

var Host: Dictionary = {
	"name": "hostgamer",
	"id": 1,
}
var Client: Dictionary = {
	"name": "clientgamer",
	"id": 3927,	# placeholder, will be set properly when llaunching the game through MainMenu.tscn
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

extends "res://Buildings/base.gd"

<<<<<<< Updated upstream
func _ready():
	super()
	add_to_group("Mines")
=======
var increase_value: int = 0
var increase_timer: Timer
var is_mine_active = false
var health = 10

const REPAIR_TIME = 30.0
var repair_remaining: float = REPAIR_TIME

func _ready():
	super._ready()
	increase_timer = Timer.new()
	increase_timer.wait_time = 1.0  # Wait time in seconds
	increase_timer.timeout.connect(_on_increase_timer_timeout)
	add_child(increase_timer)
	increase_timer.start()
	is_mine_active = true
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		is_broken = true
	if is_broken:
		if in_area.size() > 0:
			repair_remaining -= delta * in_area.size()
			if repair_remaining <= 0:
				repair_remaining = REPAIR_TIME
				is_broken = false
				print("Repair complete!")
			print("Repairing...", "Repair Remaining:", repair_remaining)
		else:
			print("Repair stopped")
	
func _on_increase_timer_timeout():
	if is_mine_active && not is_broken:
		increase_value += 1
		print("Increased Value:", increase_value)
>>>>>>> Stashed changes

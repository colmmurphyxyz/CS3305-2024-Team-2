extends "res://Buildings/Base/base.gd"
	
var reload_value: int = 0
var reload_timer: Timer

var reload: float = 7.0

const max_hp = 100.0
var health = 1.0

func _ready():
	super._ready()
	reload_timer = Timer.new()
	reload_timer.wait_time = reload  # Wait time in seconds
	reload_timer.timeout.connect(_on_reload_timeout)
	add_child(reload_timer)
	reload_timer.start()
	
func _process(delta):
	super._process(delta)
	if health <= 0:
		queue_free()
	if not health >= max_hp:
		if in_area.size() > 0:
			health += delta * in_area.size()
			if health >= max_hp:
				is_active = true
				#print("Repair complete!")
			#print("Repairing...", health, "/", max_hp)
		else:
			#print("Repair stopped")
			pass
	
func _on_reload_timeout():
	pass

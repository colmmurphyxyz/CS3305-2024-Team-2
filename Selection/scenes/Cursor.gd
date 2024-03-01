extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	$AudioStreamPlayer2D.pitch_scale = randf_range(.9,1.1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_animated_sprite_2d_animation_looped():
	queue_free()

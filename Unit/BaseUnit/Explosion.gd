extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimatedSprite2D.play("default")
	
	if is_instance_valid($Bullet_hit):
		$Bullet_hit.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass


func _on_animated_sprite_2d_animation_looped():
	$AnimatedSprite2D.queue_free()




func _on_bullet_hit_finished():
	queue_free()

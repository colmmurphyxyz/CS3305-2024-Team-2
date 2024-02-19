extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	$AnimatedSprite2D.play("default")
	if is_instance_valid($Bullet_hit):
		$Bullet_hit.play()
	pass # Replace with function body.

func _process(_delta: float):
	pass


func _on_animated_sprite_2d_animation_looped():
	queue_free()




func _on_bullet_hit_finished():
	queue_free()

extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	$AnimatedSprite2D.play("default")

func _process(_delta: float):
	pass


func _on_animated_sprite_2d_animation_looped():
	$AnimatedSprite2D.queue_free()
	queue_free()


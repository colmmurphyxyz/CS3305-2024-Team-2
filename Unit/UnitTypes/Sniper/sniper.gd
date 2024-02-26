extends Unit

func _process(delta):
	if sprite2d.frame==1 and sprite2d.animation == "attack":
		pass
		#if is_instance_valid($Body/ChargeSound):
			#if $Body/ChargeSound.playing == false:
				#$Body/ChargeSound.play()
		

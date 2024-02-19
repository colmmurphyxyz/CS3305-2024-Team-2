extends Node2D

class_name State

#Unit script is the persistant state
var change_state
var animated_sprite
var persistent_state:Unit

func setup(change_state, animated_sprite, persistent_state):
	@warning_ignore("shadowed_variable") self.change_state = change_state
	@warning_ignore("shadowed_variable") self.animated_sprite = animated_sprite
	@warning_ignore("shadowed_variable") self.persistent_state = persistent_state


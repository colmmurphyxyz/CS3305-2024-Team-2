extends Node2D

class_name State

#Unit script is the persistant state
var change_state
var animated_sprite
var persistent_state

func setup(change_state, animated_sprite, persistent_state):
	self.change_state = change_state
	self.animated_sprite = animated_sprite
	self.persistent_state = persistent_state


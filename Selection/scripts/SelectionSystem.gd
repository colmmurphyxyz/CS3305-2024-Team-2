extends Node2D

var dragging = false
var selected = []

var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()

@onready var select_draw = $DrawSelection

func _unhandled_input(event):
	#If mouse is clicked without dragging it, deselect all objects 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var prev_selected=[]
			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("deselect"):
						if Input.is_key_pressed(KEY_SHIFT):
							prev_selected.append(unit)
						else:	
							unit.collider.get_parent().deselect()
			print("prev slected",prev_selected)
			selected = []
			selected.append_array(prev_selected)
			dragging = true
			drag_start = event.position
		#If dragging mouse, draw a box, anything in that box is added to selected array
		elif dragging:
			dragging = false
			select_draw.update_status(drag_start, event.position, dragging)
			var drag_end = event.position
			select_rectangle.extents = abs((drag_end - drag_start) / 2)
			var space = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			query.set_shape(select_rectangle)
			query.transform = Transform2D(0, (drag_end + drag_start)/2)
			selected = space.intersect_shape(query,512)
			
			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("select") and is_instance_valid(unit.collider):
						unit.collider.get_parent().select()

	if dragging:
		if event is InputEventMouseMotion:
			select_draw.update_status(drag_start, event.position, dragging)
	
	#When right click, give unit a path
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_released():
			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("select"):
						var pos:Vector2 = get_viewport().get_mouse_position()
						unit.collider.get_parent().path_to_point(pos)


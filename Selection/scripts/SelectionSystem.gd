extends Node2D

var dragging = false
var selected = []

var drag_start = Vector2.ZERO
var select_rectangle = RectangleShape2D.new()
var team="1"
@onready var select_draw = $DrawSelection
func _unhandled_input(event):
	
	#If mouse is clicked without dragging it, deselect all objects 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("deselect"):
							unit.collider.get_parent().deselect()
			selected = []
			dragging = true
			drag_start = get_viewport().get_camera_2d().get_global_mouse_position()
		#If dragging mouse, draw a box, anything in that box is added to selected array
		elif dragging:
			dragging = false
			select_draw.update_status(drag_start, get_viewport().get_camera_2d().get_global_mouse_position(), dragging)
			var drag_end = get_viewport().get_camera_2d().get_global_mouse_position()
			select_rectangle.extents = abs((drag_end - drag_start) / 2)
			var space = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			query.set_shape(select_rectangle)
			query.collision_mask=1 
			query.transform = Transform2D(0, (drag_end + drag_start)/2)
			selected = space.intersect_shape(query,512)

			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("select") and is_instance_valid(unit.collider):
						unit.collider.get_parent().select()
						unit.collider.get_parent().reset_chase()
						
	if dragging:
		if event is InputEventMouseMotion:
			select_draw.update_status(drag_start, get_viewport().get_camera_2d().get_global_mouse_position(), dragging)
	
	#When right click check if theres a building or unit under cursor,

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_released():
			for unit in selected:
				if is_instance_valid(unit.collider):
					if unit.collider.get_parent().has_method("select") and is_instance_valid(unit.collider):
						var pos:Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
						var cursor_unit = get_node_under_cursor(pos)
						if cursor_unit:
							if cursor_unit in get_tree().get_nodes_in_group("Buildings"):
								unit.collider.get_parent().target_building=cursor_unit
								unit.collider.get_parent().change_state("interacting_with_building")

								break;
							else:
								unit.collider.get_parent().set_chase(cursor_unit)
						unit.collider.get_parent().path_to_point(pos)
					
func get_node_under_cursor(cursor_position: Vector2) :

	var space = get_world_2d().direct_space_state
	var check_under_cursor_rectangle:RectangleShape2D = RectangleShape2D.new()
	check_under_cursor_rectangle.set_size(Vector2(3,3))
	check_under_cursor_rectangle.extents = Vector2(1.5, 1.5)  # Set extents to half the size of the rectangle
	
	var rect_query = PhysicsShapeQueryParameters2D.new()
	rect_query.set_shape(check_under_cursor_rectangle)
	rect_query.transform = Transform2D(0, (cursor_position))
	var nodes_under = space.intersect_shape(rect_query,32)
	if nodes_under.is_empty():
			return null
			
	var return_value =nodes_under.pop_front().collider
	if return_value.get_parent().has_method("select") || return_value.has_method("select"):
		return return_value
	else: return null


	

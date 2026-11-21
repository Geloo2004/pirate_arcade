extends Node2D

@export var trajectory_line: Line2D
@export var radius: float = 180

@export var tangent0: Line2D
@export var tangent1: Line2D

var movement_direction: Vector2 = Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_draw_circle()
	pass # Replace with function body.

func _update_trajectory(angle: float, target: Vector2)->void:
	trajectory_line.clear_points()
	#trajectory_line.add_point(Vector2(0,0))
	trajectory_line.add_point(_get_circle_point(0))
	var num_steps = 10
	var step = angle / num_steps
	for i in range(num_steps):
		trajectory_line.add_point(_get_circle_point(step * i))
	trajectory_line.add_point(target)
	return

func _get_tangent_lines(target: Vector2, center: Vector2, radius: float) -> Vector4:
	var target_to_center: Vector2 = center - target
	var distance: float = sqrt(target_to_center.length_squared() - radius * radius)
	var target_angle_to_point: float = atan(radius/distance)
	var target_to_point = target_to_center.normalized() * distance
	var point0: Vector2 = target_to_center.rotated(2 * target_angle_to_point)
	var point1: Vector2 = target_to_center.rotated(-2 * target_angle_to_point)
	return Vector4(point0.x,point0.y,point1.x,point1.y)

func _get_circle_point(angle: float) -> Vector2:
	var result: Vector2
	result = Vector2(radius * sin(angle), radius * cos(angle))
	return result
	
func _draw_circle() -> void:
	var num_steps = 360
	var step = 2 * PI / num_steps
	for i in range(num_steps):
		trajectory_line.add_point(_get_circle_point(step * i))
	return
	
func _normalize_target_position(origin_pos: Vector2, target_pos: Vector2) -> Vector2:
	# we don't look for targets, that are behind us
	# only forward, left and right.
	
	# then we normalize the target position to be a vector
	# target_direction = target_pos - origin_pos
	
	var target_direction: Vector2 = target_pos - origin_pos
	# this will suffice for now, but we will need to make it work in movement_direction
	# it may rotate but for testing it is set to Vector2.UP
	# if the movement_direction's angle to target_direction is greater than abs(PI/2):
	# project the target_direction onto the vector perpendicular to movement_direction
	target_direction.x = max(0, target_direction.x)
	return target_pos
	
# returns the tangent point closest to the origin
func _get_closest_point(origin: Vector2, point0: Vector2, point1: Vector2) -> Vector2:
	# target is normalized at this point so the only case 
	# when both points have the same distance is when the target lies directly to the right
	# in all other cases the closest point is the correct one	
	var p0_to_origin = point0 - origin
	if abs(movement_direction.angle_to(p0_to_origin))>PI/2:
		return point1
	var p1_to_origin = point1 - origin
	if(p0_to_origin.length_squared()<p1_to_origin.length_squared()):
		return point0
	return point1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var origin: Vector2 = Vector2.ZERO
	tangent0.clear_points()
	tangent1.clear_points()
	var mouse_coordinates = get_global_mouse_position()
	var target_vector: Vector2 = mouse_coordinates - Vector2.ZERO
	var line_points: Vector4 = _get_tangent_lines(target_vector, origin, radius)
	var closest_point: Vector2 = _get_closest_point(origin, Vector2(line_points.x,line_points.y), Vector2(line_points.z,line_points.w))

	pass

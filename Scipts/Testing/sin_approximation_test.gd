extends Node

@export var line: Line2D
@export var circle_line: Line2D
var points: Array[Vector2]
var length: int = 100
var target_direction: Vector2 = Vector2(100,0)
var movement_direction: Vector2 = Vector2(0,100)
var delta_time: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for l in range(length):
		points.append(Vector2.ZERO)
	_draw_circle()
	
	for l in range(length):
		var point_x = ((movement_direction.x + target_direction.x) * (l*l) / (length * length))
		var point_y = ((movement_direction.y + target_direction.y) * (l) / length)
		points[l] = Vector2(point_x, point_y) * 100
	_update_line()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_wheel_input: float
	if (Input.is_action_just_pressed("wheel_up")):
		mouse_wheel_input = 1
	elif (Input.is_action_just_pressed("wheel_down")):
		mouse_wheel_input = -1
	return
	for l in range(length):
		var point_x = sin((movement_direction.x + target_direction.x)*l/length)
		var point_y = cos((movement_direction.y + target_direction.y)*l/length)
		points[l] = Vector2(point_x, point_y)*100
	_update_line()
	pass

func _draw_circle() -> void:
	var a = 2 * PI/36
	for i in range(36):
		var point = Vector2(100 + sin(a*i) * 100,cos(a*i) * 100)
		circle_line.add_point(point)

func _update_line() -> void:
	line.clear_points()	
	for l in range(length):
		line.add_point(points[l])
	return

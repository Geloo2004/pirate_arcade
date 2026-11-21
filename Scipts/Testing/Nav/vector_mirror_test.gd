extends Node

@export var target: Node2D
@export var a: Node2D
@export var b: Node2D
@export var bt: Node2D

@export var a_line: Line2D
@export var b_line: Line2D

var a_target: Vector2
var b_target: Vector2

@export var a_velocity: float = 5
@export var b_velocity: float = 8

@export var a_radius: float = 10
@export var b_radius: float = 10

var a_direction: Vector2
var b_target_direction: Vector2
var b_current_direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	a_target = target.global_position
	b_target = target.global_position
	
	a_direction = (target.global_position - a.global_position).normalized()
	b_target_direction = (target.global_position - b.global_position).normalized()
	pass # Replace with function body.

# returns ship's position with current speed and direction
# here just check whether they collide will suffice
func estimate_position(delta: float) -> void:
	return

func get_farther_node() -> Node2D:
	var ax_vector: Vector2 = target.global_position - a.global_position
	var bx_vector: Vector2 = target.global_position - b.global_position
	if(ax_vector.length_squared() > bx_vector.length_squared()):
		return a
	return b

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# update directions
	b_target_direction = (target.global_position - b.global_position).normalized()
	
	
	# if collide soon (delta = 0.2?) -> update the direction of the one farther from target
	# vector = closer to farther
	var ab : Vector2 = a.global_position - b.global_position
	print(ab.length())
	# if distance is less than threshold radius
	if ab.length() <= a_radius+b_radius:		
		var mirrored_ab = ab.reflect(b_target_direction)
		b_target = b.global_position + mirrored_ab
	else:
		b_target = target.global_position	
	a_direction = (a_target - a.global_position).normalized()
	b_current_direction = (b_target - b.global_position).normalized()
	
	a.global_position += a_direction * a_velocity * delta
	b.global_position += b_current_direction * b_velocity * delta
	bt.global_position = b_target
	
	a_line.add_point(a.global_position)
	b_line.add_point(b.global_position)
	return

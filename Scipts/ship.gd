extends Node2D

class_name Ship

var movement_direction : Vector2 # can be rotated but must always have the same length = 1
@export var angular_velocity : float = 40
@export var base_velocity : float = 250
@export var current_velocity : float = 250
@export var walked_path_line: Line2D
@export var next_position_line: Line2D
@export var target_direction_line: Line2D
@export var fire_directions_line: Line2D
var target_direction: Vector2
# cache next position to avoid recaulculation
var next_position: Vector2
var circle_radius: float
@export var firing_directions: Array[Vector2]
@export var repulsion_strength: float = 8
var clear_walked_points: bool = false

func _init() -> void:
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	angular_velocity = angular_velocity * 2 * PI / 180
	current_velocity = base_velocity
	movement_direction = Vector2.from_angle(self.global_rotation)
	circle_radius = 2 * PI * base_velocity / angular_velocity
	# prepare firing directions
	_update_firing_directions(self.global_rotation)
	return

func _update_firing_directions(angle: float) -> void:
	print('firing_directions: ', firing_directions[0], ' length = ', firing_directions[0].length())
	var new_firing_directions: Array[Vector2]
	for firing_direction in firing_directions:
		var rotated_vector = firing_direction.rotated(angle)
		print('rotated_vector: ', rotated_vector, ' length = ', rotated_vector.length())
		new_firing_directions.append(rotated_vector)
	firing_directions = new_firing_directions
	return

# return a position, that will be reached with current movementDir in delta seconds
func update_next_position(delta: float) -> void:
	next_position = global_position + movement_direction * delta
	#next_position = global_position + (target_direction + movement_direction) / 2 * delta

func update_target_direction(target_position: Vector2) -> void:
	target_direction = (target_position - self.global_position).normalized()

# to move our ship we need time and target_direction
# we update our movement_direction based on target_direction
# then move and rotate
# P.S. for player target_direction = input
func sail(delta: float, target_direction: Vector2) -> void:
	if target_direction != Vector2.ZERO:
		# ROTATION
		# find the difference between current and required
		#print('target_direction = ', target_direction, '; movement_direction = ', movement_direction)
		var angle_to_target = movement_direction.angle_to(target_direction)
		#print('angle_to_target: ' , angle_to_target * 180 / PI)
		# find rotation for this frame
		var rotation_angle = sign(angle_to_target) * delta * angular_velocity
		# if rotation angle is greater than necessary, set it to angle_to_target
		if abs(rotation_angle) >= abs(angle_to_target):
			#print('rotation_angle = angle_to_target')
			rotation_angle = angle_to_target
		rotate(rotation_angle)
		movement_direction = movement_direction.rotated(rotation_angle)
		_update_firing_directions(rotation_angle)
	
	# POSITION
	#movement_direction
	global_position += movement_direction * current_velocity * delta
	
	# path
	_update_walked_path()
	#display_next_position()
	show_target_direction(target_direction)
	show_fire_directions()
	return

func _update_walked_path() -> void:
	if (clear_walked_points):
		walked_path_line.remove_point(0)
	elif (walked_path_line.get_point_count()>900):
		clear_walked_points = true
	walked_path_line.add_point(global_position)


func show_fire_directions() -> void:
	fire_directions_line.clear_points()
	for dir in firing_directions:
		fire_directions_line.add_point(global_position)
		fire_directions_line.add_point(global_position + dir )
	return
	
func show_target_direction(target_direction: Vector2) -> void:
	target_direction_line.clear_points()
	target_direction_line.add_point(global_position)
	target_direction_line.add_point(global_position + target_direction * 100)
	return
	
	

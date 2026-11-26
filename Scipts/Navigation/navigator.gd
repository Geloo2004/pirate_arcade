extends Node

@export var ai_ships: Array[Ship]
var array_length: int
var _repulsion_coefficient_squared: float
@export var target: Ship
var repulsion_vectors: Array[Vector2]

@export var point_line: Line2D
@export var line_line: Line2D
@export var target_line: Line2D

# for each ship find next position with certain delta
# for each ship check distance to other ships
# calculate repulsion between shipas that are close to each other
# adjust vectors


# находим все корабли и счиатем для них отталкивание
# ИЛИ НЕТ
# Отталкивание кораблей высчитываем в парах.
# Кто ближе - тот на месте, у другого добавляем вектор отталкивания
# Когда рассчитаем всех - применяем

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 0.1
	array_length = ai_ships.size()
	pass # Replace with function body.

# from next positions use to get an array of lengths of vectors
# or we could just find vectors themselves TODO
func get_squared_distances_to_target(positions: Array[Vector2], target_pos: Vector2) -> Array[float]:
	var result: Array[float]
	for position in positions:
		var vector: Vector2 = target_pos - position
		result.append(vector.length_squared())
	return result

func get_closest_firing_direction(ship: Ship) -> Vector2:
	# base distance to target
	var ship_to_target = target.next_position - ship.global_position
	var closest_firing_position_distance: float = (ship_to_target - ship.firing_directions[ship.remembered_firing_direction_index]).length_squared()
	var closest_firing_direction: Vector2 = ship.firing_directions[ship.remembered_firing_direction_index]
	var firing_position: Vector2
	for i in range(1, len(ship.firing_directions)):
		# subtract the firing direction from base vector to get final vector
		firing_position = ship_to_target - ship.firing_directions[i]
		var firing_position_distance: float = firing_position.length_squared() 
		if (firing_position_distance < closest_firing_position_distance):
			# add a small threshold so they don't switch easily
			closest_firing_position_distance = firing_position_distance + 5000
			closest_firing_direction = ship.firing_directions[i]
			ship.remembered_firing_direction_index = i
	return closest_firing_direction

func _physics_process(delta: float) -> void:
	# first precalculate next positions
	for ai_ship in ai_ships:
		ai_ship.update_next_position(1)
	target.update_next_position(1)

	# ONLY USE CURRENT POSITION WHEN AIMING.
	# USING next_position IS DUMB BECAUSE IT'S ONLY AN ESTIMATEssssssdddd
	var repulsion_vectors: Array[Vector2] = _calculate_repulsion_vectors(delta)
	for i in range(array_length):
		var ship = ai_ships[i]
		# determine closest fire position
		var closest_fire_direction = ship.firing_directions[0]
		closest_fire_direction = get_closest_firing_direction(ship)
		# convert the direction into global position and find closest
		# OLD STUFF: aim for one distance
		# var target_vector = target.next_position - ship.next_position - closest_fire_direction
		
		# project ship.next_position onto closest_fire_direction then clamp it between min and max fire distances
		var projection_line_a: Vector2 = target.next_position
		var projection_line_b: Vector2 = target.next_position - closest_fire_direction
		var projection_point: Vector2 = ship.global_position
		
		#AB vector
		var projection_line: Vector2 = projection_line_b - projection_line_a
		#AC vector
		projection_point -= projection_line_a
		
		var t: float = projection_point.dot(projection_line) / projection_line.dot(projection_line)
		t = clampf(t, 0.5, 1.0)
		var clamped_projected_point: Vector2 = projection_line_a + t * projection_line
		# move from current position to firing position
		var target_vector = clamped_projected_point - ship.global_position
		
		#point_line.clear_points()
		#point_line.add_point(ship.global_position)
		#point_line.add_point(clamped_projected_point)
		#
		#line_line.clear_points()
		#line_line.add_point(projection_line_a)
		#line_line.add_point(projection_line_b)
		#
		#target_line.clear_points()
		#target_line.add_point(ship.global_position)
		#target_line.add_point(ship.global_position+target_vector)
		
		var target_direction = target_vector.normalized()
		
		target_direction = (target_direction + repulsion_vectors[i]).normalized()
		ship.show_target_direction(target_direction)
		ship.sail(delta, target_direction)
	return

# REPULSION

# implementation 1: repulsion is normalized vector (sum of repulsions from all other ships + movement_direction)
func _calculate_repulsion_vectors(delta: float) -> Array[Vector2]:
	# sum of all calculated repulsions
	repulsion_vectors.clear()
	# create empty array for table
	for i in range(array_length):
		repulsion_vectors.append(Vector2.ZERO)
	for i in range(array_length):
		for j in range(i + 1, array_length):
			# ship positions
			var pos_a: Vector2 = ai_ships[i].next_position
			var pos_b: Vector2 = ai_ships[j].next_position
			# repulsion unscaled (b -> a)
			var repulsion_vector: Vector2 = pos_a - pos_b
			# if repulsion is in the same direction as movement 
			# repulsion won't work so we need add a bit of force to the side
			if (ai_ships[i].movement_direction.cross(repulsion_vector)):
				repulsion_vector += repulsion_vector.orthogonal()/10
			# repulsion strength. The closer, the stronger the repulsion.
			# avoid division by 0
			# ✨✨✨✨✨✨✨✨✨✨
			# IF WE CALCULATE REPULSION STRENGTH SEPARATELY WE CAN IMPLEMENT NAVIGATION PRIORITY!!
			# LIKE BIG SHIPS GO FIRST ETC.
			var repulsion_strength = (ai_ships[i].repulsion_strength * ai_ships[j].repulsion_strength) / (repulsion_vector.length_squared() + 0.001)
			# influence threshold
			#if(repulsion_strength < repulsion_threshold):
			#	continue
			# repulsion scaled
			repulsion_vector = repulsion_vector * repulsion_strength
			# add to already calculated repulsions
			repulsion_vectors[i] += repulsion_vector
			# add inverted repulsion to the other ship so we don't have to calculate it again
			repulsion_vectors[j] -= repulsion_vector
		# repulsion from target ???
		
	return repulsion_vectors

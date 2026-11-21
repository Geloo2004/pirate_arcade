extends Node

@export var ai_ships: Array[Ship]
var array_length: int
@export var repulsion_coefficient: float = 8
var _repulsion_coefficient_squared: float
@export var target: Ship

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
	_repulsion_coefficient_squared = repulsion_coefficient * repulsion_coefficient
	Engine.time_scale = 0.5
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

func _physics_process(delta: float) -> void:
	var repulsion_vectors: Array[Vector2] = _calculate_repulsion_vectors(delta)
	for i in range(array_length):
		var ship = ai_ships[i]
		var closest_fire_direction = ship.firing_directions[0]
		var target_vector= target.global_position - ship.get_next_position(1) - closest_fire_direction		
		var target_direction = target_vector.normalized()
		
		# OLD var target_direction = (target.global_position - ship.global_position).normalized()
		# determine closest fire direction
		target_direction = (target_direction + repulsion_vectors[i]).normalized()
		#target_direction = (target_direction + repulsion_vectors[i] + closest_fire_direction).normalized()
		#if(i==0):
			#print('target.global_position: ', target.global_position,'; target_direction: ', target_direction, '; repulsion_vector: ', repulsion_vectors[i])
			#print('ship.movement_direction: ', ship.movement_direction)
		#ship.show_target_direction(target_direction)
		ship.show_movement_direction()
		
		ship.sail(delta, target_direction)

func _calculate_aiming_vectors(delta: float) -> Array[Vector2]:
	
	return [ Vector2.ZERO ]

# REPULSION

# implementation 1: repulsion is normalized vector (sum of repulsions from all other ships + movement_direction)
func _calculate_repulsion_vectors(delta: float) -> Array[Vector2]:
	# sum of all calculated repulsions
	var repulsion_vectors: Array[Vector2]
	# create empty array for table
	for i in range(array_length):
		repulsion_vectors.append(Vector2.ZERO)	
	for i in range(array_length - 1):
		for j in range(i + 1, array_length):
			# ship positions
			var pos_a: Vector2 = ai_ships[i].global_position
			var pos_b: Vector2 = ai_ships[j].global_position
			# repulsion unscaled (b -> a)
			var repulsion_vector: Vector2 = pos_a - pos_b
			# repulsion strength. The closer, the stronger the repulsion.
			var rep_strength = _repulsion_coefficient_squared / (repulsion_vector.length_squared() + 0.001) # avoid division by 0
			# repulsion scaled
			repulsion_vector = repulsion_vector * rep_strength
			# add to already calculated repulsions
			repulsion_vectors[i] += repulsion_vector
			# add inverted repulsion to the other ship so we don't have to calculate it again
			repulsion_vectors[j] -= repulsion_vector
	return repulsion_vectors

# TODO
# implementation 2: impl1 + target next position

extends Node2D

@export var target : Node2D
@export var controlled_ship : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	return
	
# if target within certain angles and range - fire
# check every frame when is loaded
func _target_in_sight() -> void:
	return

func _shoot() -> void:
	return

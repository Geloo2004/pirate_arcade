extends Node

var inputDir : Vector2 = Vector2.ZERO
@export var ship : Ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# read player input in 8 directions
	inputDir = Vector2.ZERO
	if(Input.is_action_pressed("Right")):
		inputDir.x += 1;
	if(Input.is_action_pressed("Left")):
		inputDir.x -= 1;	
	if(Input.is_action_pressed("Up")):
		inputDir.y -= 1;
	if(Input.is_action_pressed("Down")):
		inputDir.y += 1;		
	ship.sail(delta, inputDir)

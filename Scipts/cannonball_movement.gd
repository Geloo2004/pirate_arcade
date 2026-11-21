extends Node2D

class_name Cannonball

var tween_anim : Tween

func _init() -> void:
	tween_anim = self.create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation() -> void:
	tween_anim.set_trans(Tween.TRANS_BOUNCE)
	tween_anim.tween_property($Sprite2D, "scale", Vector2(4,4), 3)
	return
	
func explode() -> void:
	print("BOOM!")
	return

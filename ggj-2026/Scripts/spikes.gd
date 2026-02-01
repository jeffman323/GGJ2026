extends Sprite2D

var restartDelay = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(restartDelay > 0) :
		restartDelay -= delta
		if(restartDelay <= 0):
			get_tree().call_deferred("reload_current_scene")
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	restartDelay = 0.7
	
	pass # Replace with function body.

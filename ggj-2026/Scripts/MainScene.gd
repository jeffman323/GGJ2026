extends Node2D

@onready var Player = $PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.levelUp.connect(advanceLevel)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func advanceLevel(level: int):
	match level:
		1:
			get_tree().change_scene_to_file("res://Scenes/Level1.tscn");
		2:
			#get_tree().change_scene_to_file("res://Scenes/Level2.tscn");
			pass
		3:
			pass
	pass

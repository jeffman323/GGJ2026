extends Node2D

@onready var Player = $CanvasLayerPLayer/PlayerCharacter
@onready var fader = $CanvasLayer/ColorRect

var nextLevel = 0
var transitionTime = 0
var transitioning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.levelUp.connect(beginLevelTransition)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(transitionTime>0):
		transitionTime-=delta
		if(transitionTime <= 0):
			advanceLevel(nextLevel)
		elif(transitionTime <= 2 && !transitioning):
			transitioning = true
			fader.animator.play("Fade")
	pass

func beginLevelTransition(level: int):
	
	nextLevel = level
	transitionTime = 2.5
	pass

func advanceLevel(level: int):
	match level:
		1:
			get_tree().change_scene_to_file("res://Scenes/L1.tscn");
		2:
			get_tree().change_scene_to_file("res://Scenes/L2.tscn");
		3:
			get_tree().change_scene_to_file("res://Scenes/L3.tscn");
		4:
			get_tree().change_scene_to_file("res://Scenes/L4.tscn");
		5:
			get_tree().change_scene_to_file("res://Scenes/L5.tscn");
		6:
			get_tree().change_scene_to_file("res://Scenes/L6.tscn");
		7:
			get_tree().change_scene_to_file("res://Scenes/Credits.tscn");
	pass

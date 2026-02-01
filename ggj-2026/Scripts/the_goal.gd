extends Node2D

@export var nextScene: int
@onready var animator = $Sprite2D/AnimationPlayer
@onready var Player = $"../PlayerCharacter"
@onready var fakeAnimator = $FakeGoalSprite/AnimationPlayer
@onready var fakeGoal = $FakeGoalSprite
@onready var realGoal = $Sprite2D

var spawnCountdown = 1
var lookAroundCounter = 10
var despawnCountdown = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	realGoal.visible=false
	Player.levelUp.connect(levelCompleteAnimate)
	fakeAnimator.play("goaldespawn")
	despawnCountdown = 1.0
	pass # Replace with function body.

func levelCompleteAnimate(ignore: int):
	animator.play("goalreached")
	lookAroundCounter = 25
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawnCountdown>0 && realGoal.visible==false:
		spawnCountdown-=delta
		if spawnCountdown < 0:
			realGoal.visible=true
			animator.play("GoalSpawn")
			
	lookAroundCounter-=delta
	if(lookAroundCounter<0):
		var animationReroll = randi_range(1,10)
		if(animationReroll%2==0):
			animator.play("GoalBlink1")
			lookAroundCounter = animationReroll+3
		else:
			animator.play("GoalBlink2")
			lookAroundCounter = animationReroll+3
	if despawnCountdown>0:
		despawnCountdown-=delta
		if despawnCountdown < 0:
			fakeGoal.visible=false
	pass

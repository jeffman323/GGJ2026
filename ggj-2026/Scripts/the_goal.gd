extends Node2D

@export var nextScene: int
@onready var animator = $Sprite2D/AnimationPlayer

var spawnCountdown = 1
var lookAroundCounter = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible=false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawnCountdown>0 && self.visible==false:
		spawnCountdown-=delta
		if spawnCountdown < 0:
			self.visible=true
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
	pass

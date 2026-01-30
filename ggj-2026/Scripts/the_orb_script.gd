extends RigidBody2D

@onready var Player = $"../PlayerCharacter"
@onready var mainScene = $".."
var isHeld: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.pickup.connect(getPickedUp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getPickedUp():
	if(self.position.distance_to(Player.position) < 30) && !isHeld:
		isHeld = true
		
		Player.applyOrbCarried(self)
		
		print("pickup!")
	elif isHeld:
		isHeld = false
	pass

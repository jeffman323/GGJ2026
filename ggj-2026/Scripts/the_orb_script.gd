extends RigidBody2D

@onready var Player = $"../CanvasLayerPLayer/PlayerCharacter"
@onready var mainScene = $".."
@onready var animator = $TheORBSprite/AnimationPlayer
var isHeld: bool = false

var animationTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.pickup.connect(changeHeld)
	animator.play("OrbCycle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animationTimer>0:
		animationTimer-=delta
		
		if isHeld:
			self.position+=Vector2(0,-25*delta)
			if animationTimer<0:
				self.visible = false
				self.process_mode = Node.PROCESS_MODE_DISABLED
		elif animationTimer<0:
			self.gravity_scale=1
			animator.play("OrbCycle")
	pass

func changeHeld():
	if(self.position.distance_to(Player.position) < 30) && !isHeld:
		isHeld = true
		#animate the orb
		animator.play("OrbPickup")
		animationTimer = 0.7
		Player.applyOrbCarried(self)
	elif isHeld:
		animator.play("OrbDrop")
		self.gravity_scale=0
		animationTimer = 0.6
		isHeld = false
	pass
	

extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var currentOrb: RigidBody2D
@onready var aura = $"Aura?"
@onready var globalOrb = $"../TheORB"

signal pickup

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			if currentOrb==null:
				pickup.emit()
				pass
			elif currentOrb!= null:
				dropTheOrb()
				pass
	return

func _physics_process(delta: float) -> void:
	#We need to check proximity to the orb
	if(global_position.distance_to(globalOrb.global_position) < 75 || currentOrb!=null):
		self.set_collision_layer_value(4, true)
		self.set_collision_mask_value(4, true)
		self.set_collision_layer_value(3, false)
		self.set_collision_mask_value(3, false)
	else:
		self.set_collision_layer_value(3, true)
		self.set_collision_mask_value(3, true)
		self.set_collision_layer_value(4, false)
		self.set_collision_mask_value(4, false)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func applyOrbCarried(orb: RigidBody2D):
	currentOrb = orb
	print("picked up " + currentOrb.to_string())
	self.set_collision_layer_value(4, true)
	self.set_collision_mask_value(4, true)
	self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)
	#remove the orb
	currentOrb.visible = false
	#self.aura.visible = true
	currentOrb.process_mode = Node.PROCESS_MODE_DISABLED
	return
	
func dropTheOrb():
	print("Dropped " + currentOrb.to_string())
	currentOrb.position = self.position
	currentOrb.process_mode = Node.PROCESS_MODE_INHERIT
	currentOrb.visible = true
	self.aura.visible = false
	currentOrb.move_and_collide(Vector2(0,-1))
	currentOrb = null
	self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)
	self.set_collision_layer_value(4, false)
	self.set_collision_mask_value(4, false)
	#recreate the orb at the current position
	return

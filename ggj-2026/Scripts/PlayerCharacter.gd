extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

@export var currentOrb: RigidBody2D
@onready var globalOrb = $"../../TheORB"
@onready var theGoal = $"../TheGoal"
@onready var playerSprite = $Sprite2D
@onready var animator = $Sprite2D/AnimationPlayer

var dieLockout = 0;
var lastAnimation = 0;
var movementLockoutTime = 0

signal pickup
signal levelUp

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E:
			if currentOrb==null:
				pickup.emit()
				pass
			elif currentOrb!= null:
				pickup.emit()
				dropTheOrb()
				pass
		elif event.keycode == KEY_W || event.keycode == KEY_SPACE:
			checkGoal()
		elif event.keycode == KEY_EQUAL:
			get_tree().reload_current_scene()
	return

func _physics_process(delta: float) -> void:
	#We need to check proximity to the orb and adjust collision appropriately
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
	
	#no moving if we're picking up an orb
	if (movementLockoutTime > 0.0) :
		movementLockoutTime -= delta
		dieLockout-= delta
	elif (dieLockout > 0):
		movementLockoutTime -= delta
		dieLockout-= delta
	else:
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
		
		chooseAnimation(velocity.x,velocity.y)
		
		move_and_slide()
	
func chooseAnimation(xdir: float,ydir: float):
	#lastAnimation guide:
	# idle = 1
	# orbidle = 2
	# run = 3
	# orbrun = 4
	# jump = 5
	# fall = 6
	# jumporb = 7
	# fallorb = 8
	# pickup = 9
	if(dieLockout > 0) :
		return
	
	#check for idle
	if xdir == 0 && is_on_floor() && currentOrb==null && lastAnimation!=1:
		playerSprite.frame = 0
		animator.play("idle")
		lastAnimation = 1
	#idle with orb
	elif xdir == 0 && is_on_floor() && currentOrb!=null && lastAnimation!=2:
		playerSprite.frame = 0
		animator.play("orbidle")
		lastAnimation = 2
	#moving right on ground without orb
	elif xdir >0 && is_on_floor() && currentOrb==null:
		playerSprite.flip_h = 0
		if(lastAnimation!=3):
			playerSprite.frame = 0
			animator.play("run")
			lastAnimation = 3
	#moving left on ground without orb
	elif xdir <0 && is_on_floor() && currentOrb==null:
		playerSprite.flip_h = 1
		if(lastAnimation!=3):
			playerSprite.frame = 0
			animator.play("run")
			lastAnimation = 3
	#moving right on ground with orb
	elif xdir >0 && is_on_floor() && currentOrb!=null:
		playerSprite.flip_h = 0
		if(lastAnimation!=4):
			playerSprite.frame = 0
			animator.play("orbrun")
			lastAnimation = 4
	#moving left on ground with orb
	elif xdir <0 && is_on_floor() && currentOrb!=null:
		playerSprite.flip_h = 1
		if(lastAnimation!=4):
			playerSprite.frame = 0
			animator.play("orbrun")
			lastAnimation = 4
	#jumping without orb
	elif ydir <=0 && !is_on_floor() && currentOrb==null:
		if(xdir > 0):
			playerSprite.flip_h = 0
		else:
			playerSprite.flip_h = 1
		if(lastAnimation!=5):
			playerSprite.frame = 0
			animator.play("jump")
			lastAnimation = 5
	#falling without orb
	elif ydir >0 && !is_on_floor() && currentOrb==null:
		if(xdir > 0):
			playerSprite.flip_h = 0
		else:
			playerSprite.flip_h = 1
		if(lastAnimation!=6):
			playerSprite.frame = 0
			animator.play("fall")
			lastAnimation = 6
	#jump with orb
	elif ydir <=0 && !is_on_floor() && currentOrb!=null:
		if(xdir > 0):
			playerSprite.flip_h = 0
		else:
			playerSprite.flip_h = 1
		if(lastAnimation!=7):
			playerSprite.frame = 0
			animator.play("orbjump")
			lastAnimation = 7
	#fall with orb
	elif ydir >0 && !is_on_floor() && currentOrb!=null:
		if(xdir > 0):
			playerSprite.flip_h = 0
		else:
			playerSprite.flip_h = 1
		if(lastAnimation!=8):
			playerSprite.frame = 0
			animator.play("orbfall")
			lastAnimation = 8
		
func applyOrbCarried(orb: RigidBody2D):
	#initiate animation lockout
	animator.play("orbpickup")
	movementLockoutTime = 0.7
	
	currentOrb = orb
	self.set_collision_layer_value(4, true)
	self.set_collision_mask_value(4, true)
	self.set_collision_layer_value(3, false)
	self.set_collision_mask_value(3, false)

	return
	
func dropTheOrb():
	if (movementLockoutTime > 0.0):
		return
	currentOrb.position = self.position+Vector2(0,0)
	currentOrb.linear_velocity=Vector2(0,0)
	currentOrb.process_mode = Node.PROCESS_MODE_INHERIT
	currentOrb.visible = true
	currentOrb.move_and_collide(Vector2(0,-1))
	currentOrb = null
	self.set_collision_layer_value(3, true)
	self.set_collision_mask_value(3, true)
	self.set_collision_layer_value(4, false)
	self.set_collision_mask_value(4, false)
	#recreate the orb at the current position
	return

func checkGoal():
	if self.global_position.distance_to(theGoal.global_position) < 25:
		levelUp.emit(theGoal.nextScene)
		movementLockoutTime = 1.8


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("spiked")
	animator.play("Die")
	movementLockoutTime = 0.7
	dieLockout = 0.7
	pass # Replace with function body.

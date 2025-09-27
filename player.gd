extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var sprint_factor = 1.0 
var dashspeed = 4.0
var is_dashing = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Handle the sprint

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("sprint"):
		if !is_dashing and direction:
			startdash()
	
	if direction:
		if is_dashing:
			velocity.x = direction * SPEED * dashspeed
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func startdash():
	is_dashing = true
	$DashTimer.connect("timeout", stopdash)
	$DashTimer.start()

func stopdash():
	is_dashing = false

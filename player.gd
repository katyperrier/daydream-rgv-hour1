extends CharacterBody2D


const JUMP_VELOCITY = -400.0
const MAX_JUMPS = 2

var jump_count = 0
var SPEED = 300.0
var sprint_factor = 1.0 
var dashspeed = 4.0
var is_dashing = false
var diaganol_move = Vector2(600,-600)
var is_gliding = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_just_pressed("grapple"):
		is_gliding = true
	
	if is_gliding:
		velocity = velocity.lerp(diaganol_move, 0.1)
		
		if velocity.distance_to(diaganol_move) < 5:
			is_gliding = false
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("sprint"):
		if !is_dashing and direction:
			startdash()
	if not is_gliding:
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

extends CharacterBody2D


const JUMP_VELOCITY = -450.0
const MAX_JUMPS = 2

var jump_count = 0
var SPEED = 300.0
var sprint_factor = 1.0 
var dashspeed = 4.0
var is_dashing = false
var glide_target_position: Vector2
var is_gliding = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_gliding:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	if is_on_floor():
		jump_count = 0
		
	if Input.is_action_just_pressed("grapple"):
		is_gliding = true
		queue_redraw()
		
		glide_target_position = global_position + Vector2(400,-400)
		
	if is_gliding:
		var to_target = (glide_target_position - global_position).normalized()
		velocity = to_target * 300
		if global_position.distance_to(glide_target_position) < 10:
			is_gliding = false
			velocity = Vector2.ZERO
			queue_redraw()
		
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
	
func _draw() -> void:
	if is_gliding:
		draw_line(Vector2.ZERO, to_local(glide_target_position), Color.WHITE, 2.0)
	

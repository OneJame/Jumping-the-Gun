extends CharacterBody2D


const SPEED = 500.0
const RECOIL = -900.0
const FRICTION = 1500


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func shoot():
	var mouse: Vector2 = get_viewport().get_mouse_position()
	var shoot_direction: Vector2 = (mouse - global_position).normalized()
	velocity += shoot_direction * RECOIL
	
	

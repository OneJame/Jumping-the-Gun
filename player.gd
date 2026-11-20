extends CharacterBody2D

@export var gravity := 1400.0
@export var recoil := 600.0
@export var cooldown_ground := 0.6
@export var cooldown_air := 1
@export var drag := 0.02
@export var bounce := 0.3
@export var grounded = true

@onready var gun: Node2D = $Gun

var can_fire := true

func _physics_process(delta):
	gun.look_at(get_global_mouse_position())
	velocity.y += gravity * delta
	velocity.x = move_toward(velocity.x, 0.1, drag)
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()
		
	var pre_velocity := velocity
	move_and_slide()
	if get_slide_collision_count() > 0:
		var normal := get_slide_collision(0).get_normal()
		velocity = pre_velocity.bounce(normal) * bounce
		if normal.y < -0.7 and abs(velocity.y) < 50.0:
			velocity.y = 0.0
func shoot():
	can_fire = false
	if is_on_floor():
		grounded = true
	else:
		grounded = false
	
	var aim_dir := Vector2.RIGHT.rotated(gun.global_rotation)
	var along := velocity.dot(-aim_dir)
	if along <0.0:
		velocity -= -aim_dir * along
	velocity += -aim_dir * recoil
	if grounded:
		await get_tree().create_timer(cooldown_ground).timeout
	else:
		await get_tree().create_timer(cooldown_air).timeout
	can_fire = true

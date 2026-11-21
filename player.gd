extends CharacterBody2D

@export var gravity := 1400.0
@export var recoil := 700.0
@export var cooldown_ground := 0.3
@export var cooldown_air := 0.8
@export var drag := 150
@export var bounce := 0.3
@export var friction := 200

@onready var gun: Node2D = $Gun

var can_fire := true

func _physics_process(delta):
	gun.look_at(get_global_mouse_position())
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0.0, drag * delta)
	
	if Input.is_action_just_pressed("shoot1") and can_fire:
		shoot()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	velocity = velocity.limit_length(1800.0)
	var pre_velocity := velocity
	move_and_slide()
	if get_slide_collision_count() > 0:
		var normal := get_slide_collision(0).get_normal()
		var impact := -pre_velocity.dot(normal)
		if impact > 250.0:
			velocity = pre_velocity.bounce(normal) * bounce
		else:
			velocity = pre_velocity.slide(normal)
			velocity.x = move_toward(velocity.x, 0, friction * delta)
func shoot():
	can_fire = false
	$Camera2D.add_shake(4.0)
	
	var aim_dir := Vector2.RIGHT.rotated(gun.global_rotation)
	var along := velocity.dot(-aim_dir)
	if along <0.0:
		velocity -= -aim_dir * along
	velocity += -aim_dir * recoil
	if is_on_floor():
		await get_tree().create_timer(cooldown_ground).timeout
	else:
		await get_tree().create_timer(cooldown_air).timeout
	can_fire = true

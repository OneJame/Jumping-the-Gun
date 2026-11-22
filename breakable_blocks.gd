extends StaticBody2D

@export var health := 1

func take_hit():
	health -= 1
	if health <= 0:
		queue_free()

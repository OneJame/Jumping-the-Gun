extends Camera2D

var shake := 0.0

func add_shake(amount: float):
	shake = max(shake, amount)

func _process(delta):
	shake = move_toward(shake, 0.0, 40.0 * delta)
	offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake

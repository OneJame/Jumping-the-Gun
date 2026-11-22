extends Area2D

@export var speed := 1000.0
var direction := Vector2.RIGHT

func _ready ():
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta):
	position += direction * speed * delta
	
func _on_body_entered(body):
	if body.has_method("take_hit"):
		body.take_hit()
	queue_free()

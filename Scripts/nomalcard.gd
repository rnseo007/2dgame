extends Area2D

class_name NormalCard

var speed : float = 100.0
var moveDirection : Vector2 = Vector2.ZERO
var damage : float = 1.0

func _process(delta):
	global_position += moveDirection * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

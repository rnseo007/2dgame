extends Area2D

class_name Card

var hp : int = 1
var knock_amount : float = 50.0
var attack_size = 1.0
var speed : float = 200.0
var damage : float = 1.0

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()

func _process(delta):
	position += angle * speed * delta

func enemy_hit(_area : Area2D):
	hp -= 1
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

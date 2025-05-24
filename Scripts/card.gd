extends Area2D

class_name Card

var hp : int = 3
var knock_amount : float = 100.0
var attack_size = 1.0
var speed : float = 300.0
var damage : float = 1.0

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()

func _process(delta):
	position += angle * speed * delta

func enemy_hit(area : Area2D):
	hp -= 1
	if hp <= 0:
		remove_from_array.emit(self)
		queue_free()

func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free()

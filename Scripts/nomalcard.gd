extends Area2D

class_name NormalCard

var level : int = 1
var hp : int = 1
var knock_amount = 100
var attack_size = 1.0
var speed : float = 100.0
var damage : float = 1.0

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	match level:
		1:
			hp = 1
			speed = 100
			damage = 1
			knock_amount = 100
			attack_size = 1.0

func _process(delta):
	position += angle * speed * delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()

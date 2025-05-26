extends Area2D

var hp : int = 1
var knock_amount : float = 100.0
var attack_size = 1.0
var speed : float = 400.0
var damage : int = 1

var debuff : String = "none"

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()

func _process(delta):
	position += angle * speed * delta

func enemy_hit(_area : Area2D):
	hp -= 1
	if hp <= 0:
		remove_from_array.emit(self)
		queue_free()

func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free()

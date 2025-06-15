extends Area2D

var hp : int = 1
var knock_amount : float = 100.0
var attack_size = 0.1
var speed : float = 400.0
var damage : int = 1

var debuff : String = "none"

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var line2d = $Line2D

var max_points : int = 10 #=line length


func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	line2d.clear_points()

func _process(delta):
	position += angle * speed * delta
	line2d.add_point(position)
	
	if line2d.get_point_count() >= max_points:
		line2d.remove_point(0)

func enemy_hit(_area : Area2D):
	hp -= 1
	if hp <= 0:
		remove_from_array.emit(self)
		queue_free()

func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free()

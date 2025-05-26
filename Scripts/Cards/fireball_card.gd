extends Area2D

var hp : int = 2
var knock_amount : float = 200.0
var attack_size = 1.0
var speed : float = 500.0
var damage : int = 0

var debuff : String = "burn"
var debuff_time : float = 5 #sec
var debuff_damage : int = 1
var debuff_pulse_time : float = 1 #sec
var debuff_color = Color(1, 0, 0)

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

signal remove_from_array(object)

var card_sprite

@onready var sprite = $CardSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	sprite.texture = card_sprite

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

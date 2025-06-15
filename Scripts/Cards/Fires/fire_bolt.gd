extends Area2D

var knock_amount : float = 200.0
var attack_size = 1.0
var speed : float = 300.0
var damage : int = 8

var debuff : String = "burn"
var debuff_time : float = 5 #sec
var debuff_damage : int = 1
var debuff_pulse_time : float = 0.5 #sec
var debuff_color = Color(1, 0, 0)

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var fire_trail = $FireTrail

func _ready() -> void:
	angle = global_position.direction_to(target)

func _process(delta):
	position += angle * speed * delta

func enemy_hit(_area : Area2D):
	collision.set_deferred("disabled", true)
	sprite.visible = false
	fire_trail.emitting = false
	set_process(false)

func _on_timer_timeout() -> void:
	queue_free()

func _on_fire_trail_finished() -> void:
	queue_free()

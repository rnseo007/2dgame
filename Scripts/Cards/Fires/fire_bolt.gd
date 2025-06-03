extends Area2D

var knock_amount : float = 200.0
var attack_size = 1.0
var speed : float = 300.0
var damage : int = 0

var debuff : String = "burn"
var debuff_time : float = 5 #sec
var debuff_damage : int = 1
var debuff_pulse_time : float = 1 #sec
var debuff_color = Color(1, 0, 0)

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

#@onready var particle = $GPUParticles2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle()
	#particle.process_material.gravity = Vector3(angle.x*speed/10, angle.y*speed/10, 0)

func _process(delta):
	position += angle * speed * delta

func enemy_hit(_area : Area2D):
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

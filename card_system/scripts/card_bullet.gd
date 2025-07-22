extends Area2D

var knock_amount : float
var attack_size : float
var speed : float
var damage : int

var debuff : String
var debuff_time : float #sec
var debuff_damage : int
var debuff_pulse_time : float #sec
var debuff_color : Color

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var particle : GPUParticles2D
@onready var shader_material : ShaderMaterial

func _ready() -> void:
	angle = global_position.direction_to(target)
	particle.finished.connect(_on_particle_finished)
	material = shader_material

func _process(delta):
	position += angle * speed * delta

func enemy_hit(_area : Area2D):
	collision.set_deferred("disabled", true)
	sprite.visible = false
	set_process(false)
	$Timer.stop()

func _on_timer_timeout() -> void:
	queue_free()

func _on_particle_finished() -> void:
	queue_free()

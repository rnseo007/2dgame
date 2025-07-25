extends Area2D

var card_data : CardData

#var knock_amount : float
#var attack_size : float
#var speed : float
#var damage : int

#var debuff : String
#var debuff_time : float #sec
#var debuff_damage : int
#var debuff_pulse_time : float #sec
#var debuff_color : Color

var target : Vector2 = Vector2.ZERO
var angle : Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var effects = $Effects

var particles : Array

func _ready() -> void:
	angle = global_position.direction_to(target)
	
	if card_data.pacticles.size() > 0:
		for i in range(0, card_data.pacticles.size()):
			var new_particle = card_data.pacticles[i].instantiate()
			effects.add_child(new_particle)
			new_particle.finished.connect(_on_particle_finished)
			particles.append(new_particle)
	
	if card_data.material != null:
		sprite.material = card_data.material

func _process(delta):
	position += angle * card_data.speed * delta

func enemy_hit(_area : Area2D):
	collision.set_deferred("disabled", true)
	sprite.visible = false
	for i in range(0, particles.size()):
		particles[i].emitting = false
	set_process(false)
	timer.stop()

func _on_timer_timeout() -> void:
	queue_free()

func _on_particle_finished() -> void:
	queue_free()

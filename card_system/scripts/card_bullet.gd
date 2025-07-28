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
@onready var timer = $Timer
@onready var particle_effects = $ParticleEffects
@onready var other_effects = $OtherEffects

@onready var sprite : Sprite2D = $Sprites/Sprite2D
var particles : Array
var hit_entity : Array
var hp : int

func _ready() -> void:
	angle = global_position.direction_to(target)
	hp = card_data.hp
	
	if card_data.pacticle_effects.size() > 0:
		for i in range(0, card_data.pacticle_effects.size()):
			var new_particle = card_data.pacticle_effects[i].instantiate()
			particle_effects.add_child(new_particle)
			new_particle.finished.connect(_on_particle_finished)
			particles.append(new_particle)
	
	if card_data.other_effects.size() > 0:
		for i in range(0, card_data.other_effects.size()):
			var new_other_effect = card_data.other_effects[i].instantiate()
			other_effects.add_child(new_other_effect)
	
	if card_data.material != null:
		sprite.material = card_data.material

func _process(delta):
	position += angle * card_data.speed * delta

func enemy_hit(area : Area2D):
	if hit_entity.has(area):
		return
	hp -= 1
	hit_entity.append(area)
	if hp > 0:
		return
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

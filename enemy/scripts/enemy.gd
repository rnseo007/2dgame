extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : int = 50
@export var knockback_recovery = 5.0
@export var xp_drop_chance : int = 50 # % percent
@export var xp_amount : int = 5

@onready var sprite = $Enemy_sprite2D
@onready var walk_anim = $WalkAnimationPlayer
@onready var hit_anim = $HitAnimationPlayer
@onready var debuff_times = $DebuffTimes
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")

var knockback : Vector2 = Vector2.ZERO

var debuff_damage : Dictionary[String, int]
var debuff_slow : int = 0
var debuff_pulse_timers : Array
var debuff_timers : Array

var hit_once_array = []

var experince_object = preload("res://enemy/scenes/experience.tscn")

func _ready():
	walk_anim.play("walk")

func death():
	var new_exp = experince_object.instantiate()
	new_exp.global_position = global_position
	new_exp.experience = xp_amount
	loot_base.get_tree().current_scene.call_deferred("add_child", new_exp)
	queue_free()

func _process(_delta):
	_recover_knockback()
	velocity = _compute_move_velocity() + knockback
	
	move_and_slide()

func _recover_knockback():
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)

func _compute_move_velocity() -> Vector2:
	var dir = (player.global_position - global_position).normalized()
	var spd = max(speed - float(debuff_slow), 0)
	_flip_sprite_by_dir(dir.x)
	return dir * spd

func _flip_sprite_by_dir(dir):
	if dir > 0.1:
		sprite.flip_h = false
	elif dir < -0.1:
		sprite.flip_h = true

func _on_hit_box_entered(area: Area2D) -> void:
	var player_bullet = area as Node
	var pb_data = player_bullet.card_data
	take_damage(pb_data.damage, pb_data.knock_amount, player_bullet.angle)
	if pb_data.abilities != null:
		var pb_debuff = pb_data.abilities
		take_debuff(pb_debuff.debuff_name, pb_debuff.debuff_time, pb_debuff.debuff_damage, pb_debuff.debuff_pulse_time, pb_debuff.debuff_color)

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func calculate_hp(dmg : int):
	cur_hp -= dmg
	if cur_hp <= 0:
		death()

func _on_debuff_timer_timeout(type) -> void:
	#debuff_pulse_timer.stop()
	debuff_damage[type] = 0
	self_modulate = Color(0, 0, 0,0)

func _on_debuff_pulse_timer_timeout() -> void:
	hit_anim.play("Hit_Animation")
	#calculate_hp(debuff_damage)
	#debuff_pulse_timer.start()

func take_damage(damage_amount : int, knock_amount : float, knock_angle : Vector2):
	calculate_hp(damage_amount)
	hit_anim.play("Hit_Animation")
	knockback = knock_angle * knock_amount
	pass

func take_debuff(debuff_name : String, debuff_time : float, debuff_damage_amount : int, debuff_pulse_time : float, debuff_color : Color):
	if debuff_damage.has(debuff_name):
		debuff_damage[debuff_name] = debuff_damage_amount
	
	_start_debuff_timer(debuff_time, debuff_name)
	
	_compute_debuff_color(debuff_color)
	#if debuff_pulse_time > 0:
		#debuff_pulse_timer.wait_time = debuff_pulse_time
		#if debuff_pulse_timer.is_stopped():
		#	debuff_pulse_timer.start()

func _start_debuff_timer(time : float, name : String) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.name = "debuff_timer_" + name
	debuff_times.add_child(timer)
	timer.timeout.connect(_on_debuff_timer_timeout).bind(name)
	timer.start()
	return timer

func _compute_debuff_color(debuff_color):
	sprite.self_modulate = debuff_color

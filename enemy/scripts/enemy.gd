extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : int = 50
@export var knockback_recovery = 5.0
@export var xp_drop_chance : int = 50 # % percent
@export var xp_amount : int = 50

@onready var sprite = $Enemy_sprite2D
@onready var walk_anim = $WalkAnimationPlayer
@onready var hit_anim = $HitAnimationPlayer
@onready var debuff_times = $DebuffTimes
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")

var knockback : Vector2 = Vector2.ZERO

var active_debuffs := {}
var slow_debuff_amount : int

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
	var spd = max(speed - float(slow_debuff_amount), 0)
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
	if pb_data.debuff != null:
		var pb_debuff = pb_data.debuff
		take_debuff(pb_debuff.type, pb_debuff.name, pb_debuff.duration, pb_debuff.damage, pb_debuff.pulse_time, pb_debuff.color)

func calculate_hp(dmg : int):
	cur_hp -= dmg
	if cur_hp <= 0:
		death()

func take_damage(damage_amount : int, knock_amount : float, knock_angle : Vector2):
	calculate_hp(damage_amount)
	hit_anim.play("Hit_Animation")
	knockback = knock_angle * knock_amount

func take_debuff(type : int, d_name : String, duration : float, damage_amount : int, pulse_time : float, color : Color):
	#만약 적용된 디버프라면
	if active_debuffs.has(d_name):
		active_debuffs[d_name].duration_timer.stop()
		active_debuffs[d_name].duration_timer.start()
	else :
		var inst := {}
		#새 지속 시간 타이머
		var duration_timer = Timer.new()
		duration_timer.wait_time = duration
		duration_timer.one_shot = true
		duration_timer.timeout.connect(Callable(self, "_on_debuff_duration_timeout").bind(d_name))
		debuff_times.add_child(duration_timer)
		duration_timer.start()
		
		inst["duration_timer"] = duration_timer
		
		if type == DebuffType.type.DAMAGE:
			var pulse_timer = Timer.new()
			pulse_timer.wait_time = pulse_time
			pulse_timer.one_shot = false
			pulse_timer.timeout.connect(Callable(self, "_on_debuff_pulse_timeout").bind(damage_amount))
			debuff_times.add_child(pulse_timer)
			pulse_timer.start()
			
			inst["pulse_timer"] = pulse_timer
		elif type == DebuffType.type.STATUS:
			slow_debuff_amount += damage_amount
			inst["slow_debuff_amount"] = damage_amount
		
		sprite.self_modulate = color
		active_debuffs[d_name] = inst

#디버프 지속시간 끝
func _on_debuff_duration_timeout(d_name):
	#슬로우 있을 시 해당 슬로우 만큼만 제거
	if active_debuffs[d_name].has("slow_debuff_amount"):
		slow_debuff_amount = max(slow_debuff_amount - active_debuffs[d_name].slow_debuff_amount, 0)
	#타이머 삭제
	active_debuffs[d_name].duration_timer.queue_free()
	if active_debuffs[d_name].has("pulse_timer"):
		active_debuffs[d_name].pulse_timer.queue_free()
	#디버프 삭제
	active_debuffs.erase(d_name)
	if active_debuffs.size() <= 0:
		sprite.self_modulate = Color(1,1,1,1)

func _on_debuff_pulse_timeout(damage_amount : int):
	calculate_hp(damage_amount)
	hit_anim.play("Hit_Animation")

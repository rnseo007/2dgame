extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : int = 20
@export var knockback_recovery = 3.5
@export var xp_drop_chance : int = 50 # % percent
@export var xp_amount : int = 5

@onready var sprite = $Enemy_sprite2D
@onready var walk_anim = $WalkAnimationPlayer
@onready var hit_anim = $HitAnimationPlayer
@onready var debuff_timer = $DebuffTimes/Debuff_timer
@onready var debuff_pulse_timer = $DebuffTimes/Debuff_pulse_timer
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")

var knockback : Vector2 = Vector2.ZERO
var knockback_angle : Vector2 = Vector2.ZERO
var knockback_amount : float = 1

var debuff : String = "none"
var debuff_damage : int = 0

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
	var direction = global_position.direction_to(player.global_position)
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	
	velocity = direction * speed
	velocity += knockback
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	
	move_and_slide()
	$TestText.text = "<ORC>\n{0}\nHP: {1}\nSPEED: {2}\nDebuff: {3}".format({0:global_position.floor(),1:cur_hp,2:speed,3:debuff})

func _on_hit_box_entered(area: Area2D) -> void:
	return
	if area.is_in_group("Player_Bullet"):
		if hit_once_array.has(area) == false:
			hit_once_array.append(area)
			if area.has_signal("remove_from_array"):
				if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")):
					area.connect("remove_from_array", Callable(self, "remove_from_list"))
		else:
			return
		
		var node = area as Node
		if not node.get("damage") == null:
			calculate_hp(node.damage)
			hit_anim.stop()
			hit_anim.play("Hit_Animation")
			
			if not node.get("angle") == null:
				knockback_angle = node.angle
			
			if not node.get("knock_amount") == null:
				knockback_amount = node.knock_amount
			knockback = knockback_angle * knockback_amount
			
			if not area.get("debuff") == "none" and not area.get("debuff") == null:
				debuff = area.get("debuff")
				debuff_pulse_timer.wait_time = area.get("debuff_pulse_time")
				debuff_damage = area.get("debuff_damage")
				debuff_timer.start(area.get("debuff_time"))
				if debuff_pulse_timer.is_stopped():
					debuff_pulse_timer.start()
				if not area.get("debuff_color") == null:
					sprite.self_modulate = area.get("debuff_color")

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

func calculate_hp(dmg : int):
	cur_hp -= dmg
	if cur_hp <= 0:
		death()

func _on_debuff_timer_timeout() -> void:
	debuff_pulse_timer.stop()
	debuff = "none"
	debuff_damage = 0
	self_modulate = Color(0, 0, 0,0)


func _on_debuff_pulse_timer_timeout() -> void:
	hit_anim.play("Hit_Animation")
	calculate_hp(debuff_damage)

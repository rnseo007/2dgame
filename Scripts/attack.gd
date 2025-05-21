extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")

#Attacks
var normalCard = preload("res://Scenes/Normal_Card.tscn")

#Attack Nodes
@onready var normalTimer = get_node("%NormalTimer")
@onready var normalAttackTimer = get_node("%NormalAttackTimer")

#Normal Card
var normal_ammo = 0
var normal_baseammo = 1
var normal_attackspeed = 0.5
var normal_level = 1

#Enemy Related
var enemy_close = []

func _ready() -> void:
	attack()

func attack():
	if normal_level > 0:
		normalTimer.wait_time = normal_attackspeed
		if normalTimer.is_stopped():
			normalTimer.start()

func _on_normal_timer_timeout() -> void:
	normal_ammo += normal_baseammo
	normalAttackTimer.start()

func _on_normal_attack_timer_timeout() -> void:
	var enemys : Array = get_tree().get_nodes_in_group("Enemy")
	if not enemys.size() > 0:
		normalAttackTimer.start()
		return
	
	if normal_ammo > 0:
		var normal_attack = normalCard.instantiate()
		normal_attack.position = player.global_position
		normal_attack.target = get_close_target(enemys)
		normal_attack.level = normal_level
		add_child(normal_attack)
		normal_ammo -= 1
		if normal_ammo > 0:
			normalAttackTimer.start()
		else:
			normalAttackTimer.stop()

func get_close_target(enemys):
	var cur_enemy_dist = 1000
	var cur_enemy_pos
	for i in enemys:
		var enemy_dist = player.global_position.distance_to(i.global_position)
		if enemy_dist < cur_enemy_dist:
			cur_enemy_dist = enemy_dist
			cur_enemy_pos = i.global_position
			return cur_enemy_pos
		else:
			return Vector2.ZERO

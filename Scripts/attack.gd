extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

#Attacks
var card = preload("res://Scenes/Card.tscn")

#Attack Nodes
@onready var reloadTimer = $ReloadTimer
@onready var attackTimer = $AttackTimer

#Card
var cur_ammo = 0
var max_ammo = 6
var attack_speed = 0.5
var reload_time = 1.0

#Enemy Related
var enemy_close = []

func _ready() -> void:
	reloadTimer.start(reload_time)

func _on_reload_timer_timeout() -> void:
	cur_ammo = max_ammo
	attackTimer.start(attack_speed)

func _on_attack_timer_timeout() -> void:
	var enemys : Array = get_tree().get_nodes_in_group("Enemy")
	
	if not enemys.size() > 0:
		attackTimer.start(attack_speed)
		return
	
	if cur_ammo > 0:
		var card_attack = card.instantiate()
		card_attack.position = player.global_position
		card_attack.target = get_close_target(enemys)
		add_child(card_attack)
		cur_ammo -= 1
		attackTimer.start(attack_speed)
	else:
		attackTimer.stop()
		reloadTimer.start(reload_time)

func get_close_target(enemys):
	var cur_enemy_dist = 10000
	var cur_enemy_pos : Vector2 = Vector2.ZERO
	for i in enemys:
		print(i.global_position)
		var enemy_dist = player.global_position.distance_to(i.global_position)
		if enemy_dist < cur_enemy_dist:
			cur_enemy_dist = enemy_dist
			cur_enemy_pos = i.global_position
	return cur_enemy_pos

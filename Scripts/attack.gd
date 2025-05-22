extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

#Attacks
var card = preload("res://Scenes/Card.tscn")

#Attack Nodes
@onready var reloadTimer = get_node("%ReloadTimer")
@onready var attackTimer = get_node("%AttackTimer")

#Card
var cur_ammo = 0
var max_ammo = 6
var attack_speed = 0.5

#Enemy Related
var enemy_close = []

func _ready() -> void:
	attack()

func attack():
	if reloadTimer.is_stopped():
		attackTimer.start()

func _on_reload_timer_timeout() -> void:
	cur_ammo = max_ammo
	attackTimer.start()

func _on_normal_attack_timer_timeout() -> void:
	var enemys : Array = get_tree().get_nodes_in_group("Enemy")
	
	if not enemys.size() > 0:
		attackTimer.start()
		return
	
	if cur_ammo > 0:
		var card_attack = card.instantiate()
		card_attack.position = player.global_position
		card_attack.target = get_close_target(enemys)
		add_child(card_attack)
		cur_ammo -= 1
	else:
		attackTimer.stop()
		reloadTimer.start()

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

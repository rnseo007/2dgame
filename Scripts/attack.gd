extends Node2D

class_name AttackControl

@onready var player = get_tree().get_first_node_in_group("Player")

#Attacks
var card = preload("res://Scenes/Cards/BlankCard.tscn")

#Attack Nodes
@onready var reloadTimer = $ReloadTimer
@onready var attackTimer = $AttackTimer

#Card
var cur_ammo = 0
var max_ammo = 6
var attack_speed = 0.5
var reload_time = 1.0
var inv_max = 36

#Attack Card List
@export var card_list : Array[CardList] = []
var inv_card_list : Array = []
var cur_card_list : Array = []

func _ready() -> void:
	for i in range(0, inv_max):
		inv_card_list.append(card_list[0])
	print(inv_card_list.size())
	reloadTimer.start(reload_time)

func _on_reload_timer_timeout() -> void:
	for i in range(0, max_ammo):
		cur_card_list.append(inv_card_list.pick_random())
	
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
		if cur_card_list.size() > 0:
			cur_card_list.remove_at(0)
		print(cur_card_list)
		cur_ammo -= 1
		attackTimer.start(attack_speed)
	else:
		attackTimer.stop()
		reloadTimer.start(reload_time)

func get_close_target(enemys):
	var cur_enemy_dist = 10000
	var cur_enemy_pos : Vector2 = Vector2.ZERO
	for i in enemys:
		var enemy_dist = player.global_position.distance_to(i.global_position)
		if enemy_dist < cur_enemy_dist:
			cur_enemy_dist = enemy_dist
			cur_enemy_pos = i.global_position
	return cur_enemy_pos

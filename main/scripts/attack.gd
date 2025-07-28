extends Node2D

class_name AttackControl

@onready var player = get_tree().get_first_node_in_group("Player")

#Attack Nodes
@onready var reloadTimer = $ReloadTimer
@onready var attackTimer = $AttackTimer

#call play hud
signal reload_card
signal shooted

#Card
var cur_ammo : int = 0
var max_ammo : int = 50
var attack_speed : float = 0.1
var reload_time : float = 2.0
var inv_max : int = 36

#Attack Card List
var inv_card_list : Array = []
var cur_card_list : Array = []
var card_bullet : PackedScene = preload("res://card_system/scenes/card_bullet.tscn")
@onready var card_list := preload("res://card_system/data/total_data/card_list.tres").card_list_data

func _ready() -> void:
	#inventory reset
	#inv_card_list will have only list keys
	for i in range(0, inv_max):
		inv_card_list.append(card_list.keys().pick_random())
		#inv_card_list.append("mana_shot")
	print(inv_card_list.size())
	
	#hands card get(reset)
	for i in range(0, max_ammo):
		cur_card_list.append(inv_card_list.pick_random())
	reload_card.emit()
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
		#var attack = card_list[cur_card_list[0]].instantiate()
		var new_bullet = card_bullet.instantiate()
		new_bullet.position = player.global_position
		new_bullet.target = get_close_target(enemys)
		new_bullet.card_data = card_list.get(cur_card_list[0])
		
		add_child(new_bullet)
		
		if cur_card_list.size() > 0:
			cur_card_list.remove_at(0)
		
		cur_ammo -= 1
		shooted.emit()
		attackTimer.start(attack_speed)
	else:
		attackTimer.stop()
		reloadTimer.start(reload_time)
		for i in range(0, max_ammo):
			cur_card_list.append(inv_card_list.pick_random())
		reload_card.emit()

func get_close_target(enemys):
	var cur_enemy_dist = 10000
	var cur_enemy_pos : Vector2 = Vector2.ZERO
	for i in enemys:
		var enemy_dist = player.global_position.distance_to(i.global_position)
		if enemy_dist < cur_enemy_dist:
			cur_enemy_dist = enemy_dist
			cur_enemy_pos = i.global_position
	return cur_enemy_pos

extends Node2D

class_name AttackControl

@onready var player = get_tree().get_first_node_in_group("Player")

#Attack Nodes
@onready var reloadTimer = $ReloadTimer
@onready var attackTimer = $AttackTimer

signal reload_card
signal shooted

#Card
var cur_ammo : int = 0
var max_ammo : int = 50
var attack_speed : float = 0.1
var reload_time : float = 5.0
var inv_max : int = 36

#Attack Card List
var inv_card_list : Array = []
var cur_card_list : Array = []
var card_list = {
	"blank" : preload("res://Scenes/Cards/BlankCard.tscn"),
	"fire_bolt" : preload("res://Scenes/Cards/Fires/fire_bolt.tscn")
}

func _ready() -> void:
	for i in range(0, inv_max):
		inv_card_list.append(card_list.keys().pick_random())
	print(inv_card_list.size())
	
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
		var attack = card_list[cur_card_list[0]].instantiate()
		attack.position = player.global_position
		attack.target = get_close_target(enemys)
		
		add_child(attack)
		
		if cur_card_list.size() > 0:
			cur_card_list.remove_at(0)
		
		cur_ammo -= 1
		#print("shoot")
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

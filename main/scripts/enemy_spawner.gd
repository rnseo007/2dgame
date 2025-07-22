extends Node2D

@export var spawns : Array[Spawn_Info] = []

@onready var player = get_tree().get_first_node_in_group("Player")

var time = 0

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time > i.time_start and time < i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else :
				i.spawn_delay_counter = 0
				
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = i.enemy.instantiate()
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)
					counter += 1
					#print("spawn", enemy_spawn)

func get_random_position():
	var spawn_position : Vector2 = Vector2.ZERO
	var spawn_distance = 500
	
	var ran = randf_range(-3, 3)
	
	spawn_position.x = cos(ran) * spawn_distance + player.global_position.x
	spawn_position.y = tan(ran) * spawn_distance + player.global_position.y
	
	return spawn_position

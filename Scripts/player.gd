extends CharacterBody2D

@export var speed : float = 300

#Attack cooltime max(setup)
@export var attackCoolTime : float = 1.0
@export var normalBulletSpeed : float = 400.0
@export var damage : float = 1.0
@export var normalCard : PackedScene

signal player_cur_hp(hp : int)
var cur_hp = 10
var can_Attack : bool = true

#in Attack Area enemy array
var enemy_array = []

func _ready() -> void:
	player_cur_hp.emit(cur_hp)

func rad2deg(rad):
	return rad * 180 / PI

#get nearest enemy
func getCloseEnemy():
	#current nearest enemy distance + setup to attack distance
	var close_Enemy_Dist = 1000
	#current nearest enemy
	var close_Enemy : Node2D
	
	for e in enemy_array:
		#get current enemy distance
		var cur_enemy_dist = global_position.distance_to(e.global_position)
		
		if (cur_enemy_dist < close_Enemy_Dist):
			close_Enemy_Dist = cur_enemy_dist
			close_Enemy = e
	
	return close_Enemy


func baseAttack(target):
	if !can_Attack:
		return
	if target == null:
		return
	
	can_Attack = false
	
	var base_card = normalCard.instantiate()
	
	base_card.damage = damage
	base_card.speed = normalBulletSpeed
	base_card.moveDirection = (target.global_position - global_position).normalized()
	base_card.global_position = global_position
	base_card.rotation = atan2(target.global_position.y - global_position.y, target.global_position.x - global_position.x)
	get_tree().root.add_child(base_card)
	
	
	get_tree().create_timer(attackCoolTime).timeout.connect(func(): can_Attack = true)
	#print("attack")

func _physics_process(_delta):
	#reset velocity
	velocity = Vector2.ZERO
	
	#set direction to input
	var direction := Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down"))
	if direction:
		velocity = direction.normalized() * speed
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity.x)
		$AnimationTree.set("parameters/Walk/blend_position", velocity.x)
		move_and_slide()
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
		pass
	
	if enemy_array.size() > 0:
		baseAttack(getCloseEnemy())

func _on_enemy_spawned(entity: Node2D) -> void:
	enemy_array.append(entity)

func _on_enemy_dead(entity: Node2D) -> void:
	enemy_array.erase(entity)

func _on_hit_area_2d_get_damage(dmg: int) -> void:
	cur_hp -= dmg
	player_cur_hp.emit(cur_hp)
	$HitAnimationPlayer.play("Hit")

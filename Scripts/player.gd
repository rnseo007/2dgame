extends CharacterBody2D

@export var speed : int = 300
@export var attackDistance : float = 200.0
#Attack cooltime max(setup)
@export var attackCoolTime : float = 1.0

var can_Attack : bool = true

#in Attack Area enemy array
var enemy_array = []

func _ready() -> void:
	setAttArea()

#set Attack Area func
func setAttArea():
	$Range/Range_Area.shape.radius = attackDistance

#get nearest enemy
func getCloseEnemy():
	#current nearest enemy distance + setup to attack distance
	var close_Enemy_Dist = attackDistance
	#current nearest enemy
	var close_Enemy
	
	for e in enemy_array:
		#get current enemy distance
		var cur_enemy_dist = global_position.distance_to(e.global_position)
		
		if (cur_enemy_dist < close_Enemy_Dist):
			close_Enemy_Dist = cur_enemy_dist
			close_Enemy = e
	
	return close_Enemy


func attack(target):
	if !can_Attack:
		return
	can_Attack = false
	
	#attack code here
	
	
	get_tree().create_timer(attackCoolTime).timeout.connect(func(): can_Attack = true)
	print("attack")

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
		attack(getCloseEnemy())

#if enemy in attack area
func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body)

#if enemy out attack area
func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body)

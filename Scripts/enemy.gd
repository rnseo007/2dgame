extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : float = 50
@onready var hit_anim_player = $HitAnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player")

signal spawned(entity : Node2D)
signal dead(entity : Node2D)

func _ready() -> void:
	spawned.emit($".")
	print("spawned")

func death():
	dead.emit($".")
	queue_free()

func _process(_delta):
	velocity = Vector2.ZERO
	
	var playerPos : Vector2 = player.global_position
	
	var direction = Vector2(
		0 if playerPos.x == global_position.x else -1 if playerPos.x < global_position.x else 1,
		0 if playerPos.y == global_position.y else -1 if playerPos.y < global_position.y else 1
	)
	
	velocity = direction.normalized() * speed

	if abs(playerPos.x-global_position.x) > 10:
		$AnimationTree.set("parameters/Walk/blend_position", direction.x)
	
	move_and_slide()
	$TestText.text = "<ORC>\n{0}\nHP: {1}\nSPEED: {2}".format({0:global_position.floor(),1:cur_hp,2:speed})

func take_damage(damage):
	cur_hp -= damage
	hit_anim_player.play("Hit_Animation")
	
	if cur_hp <= 0:
		death()

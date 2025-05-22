extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : int = 50

@onready var sprite = $Enemy_sprite2D
@onready var walk_anim = $WalkAnimationPlayer
@onready var hit_anim = $HitAnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	walk_anim.play("walk")

func death():
	queue_free()

func _process(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * speed
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	
	move_and_slide()
	$TestText.text = "<ORC>\n{0}\nHP: {1}\nSPEED: {2}".format({0:global_position.floor(),1:cur_hp,2:speed})

func _on_get_damage(dmg: int) -> void:
	cur_hp -= dmg
	
	hit_anim.play("Hit_Animation")
	
	if cur_hp <= 0:
		death()

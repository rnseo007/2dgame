extends CharacterBody2D

class_name Entity

@export var speed : float = 100
@export var cur_hp : int = 5
@export var knockback_recovery = 3.5
@export var xp_drop_chance : int = 50 # % percent
@export var xp_amount : int = 5

@onready var sprite = $Enemy_sprite2D
@onready var walk_anim = $WalkAnimationPlayer
@onready var hit_anim = $HitAnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")

var knockback : Vector2 = Vector2.ZERO
var knockback_angle : Vector2 = Vector2.ZERO
var knockback_amount : float = 1

var hit_once_array = []

var experince_object = preload("res://Scenes/Main_Scenes/experience.tscn")

func _ready():
	walk_anim.play("walk")

func death():
	var new_exp = experince_object.instantiate()
	new_exp.global_position = global_position
	new_exp.experience = xp_amount
	loot_base.add_child(new_exp)
	queue_free()

func _process(_delta):
	var direction = global_position.direction_to(player.global_position)
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	
	velocity = direction * speed
	velocity += knockback
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	
	move_and_slide()
	$TestText.text = "<ORC>\n{0}\nHP: {1}\nSPEED: {2}".format({0:global_position.floor(),1:cur_hp,2:speed})

func _on_hit_box_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Bullet"):
		if hit_once_array.has(area) == false:
			hit_once_array.append(area)
			if area.has_signal("remove_from_array"):
				if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")):
					area.connect("remove_from_array", Callable(self, "remove_from_list"))
		else:
			return
		
		var node = area as Node
		if not node.get("damage") == null:
			cur_hp -= node.damage
			hit_anim.stop()
			hit_anim.play("Hit_Animation")
			if not node.get("angle") == null:
				knockback_angle = node.angle
			if not node.get("knock_amount") == null:
				knockback_amount = node.knock_amount
			knockback = knockback_angle * knockback_amount
	if cur_hp <= 0:
		death()

func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(object)

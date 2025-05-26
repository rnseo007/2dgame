extends CharacterBody2D

@onready var hit_anim = $HitAnimationPlayer
@onready var grab_area = $GrabArea/CollisionShape2D

@export var movement_speed : float = 300
@export var grab_radius : float = 200
var hp = 10
var cur_xp : int = 0
var max_xp : int = 10
var level : int = 1

func _ready() -> void:
	grab_area_set()

func _physics_process(_delta):
	movement()

func movement():
	#set direction to input
	var direction := Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_up","move_down"))
	
	if direction:
		velocity = direction.normalized() * movement_speed
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity.x)
		$AnimationTree.set("parameters/Walk/blend_position", velocity.x)
		move_and_slide()
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")

func _on_get_damage(dmg : int) -> void:
	hp -= dmg
	hit_anim.stop()
	hit_anim.play("Hit")


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Loot"):
		var gxp = area.collect()
		calculate_experience(gxp)

func calculate_experience(gotxp : int):
	cur_xp += gotxp
	if cur_xp >= max_xp:
		cur_xp -= max_xp
		level += 1
		max_xp += level**2 - level*2
	print(cur_xp, ":", max_xp)

func grab_area_set():
	grab_area.shape.radius = grab_radius

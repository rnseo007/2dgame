extends CharacterBody2D

@onready var hit_anim = $HitAnimationPlayer

@export var movement_speed : float = 300
var hp = 10
var cur_xp : int = 0
var max_xp : int = 10
var level : int = 1

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

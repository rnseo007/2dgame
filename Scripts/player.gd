extends CharacterBody2D

@export var movement_speed : float = 300
signal player_cur_hp(hp : int)
var hp = 10

func _ready() -> void:
	player_cur_hp.emit(hp)

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

func _on_get_damage(dmg) -> void:
	hp -= dmg
	player_cur_hp.emit(hp)
	$HitAnimationPlayer.play("Hit")

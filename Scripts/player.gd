extends CharacterBody2D

@export var speed : int = 300

func _physics_process(_delta):
	velocity = Vector2.ZERO

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

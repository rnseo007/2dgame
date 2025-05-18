extends CharacterBody2D

@export var speed : int = 100
@export var cur_hp : float = 10

func _process(_delta):
	velocity = Vector2.ZERO
	
	var playerPos : Vector2 = $"../Player".global_position
	
	var direction = Vector2(
		0 if playerPos.x == global_position.x else -1 if playerPos.x < global_position.x else 1,
		0 if playerPos.y == global_position.y else -1 if playerPos.y < global_position.y else 1
	)
	
	velocity = direction.normalized() * speed
	
	var pte
	if abs(playerPos.x-global_position.x) > 10:
		pte = direction.x
		$AnimationTree.set("parameters/Walk/blend_position", pte)
	move_and_slide()
	$TestText.text = "<ORC>\n{0}\nHP: {1}\nSPEED: {2}".format({0:global_position.floor(),1:cur_hp,2:speed})

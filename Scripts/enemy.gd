extends CharacterBody2D

@export var speed : int = 100

@onready var playerPos : Vector2 = $"../Player".global_position

var pos = $".".global_position

func _process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	var direction = Vector2(-1 if playerPos.x < pos.x else 1, -1 if playerPos.y < pos.y else 1)
	
	velocity = direction.normalized() * speed

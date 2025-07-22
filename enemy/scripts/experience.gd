extends Area2D

@export var experience : int = 1

@onready var sprite = $Sprite2D
@onready var sound = $Sound_Collected
@onready var collision = $CollisionShape2D

var target = null
var speed : float = -2.0

func _process(delta: float) -> void:
	if not target == null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 10 * delta

func collect():
	sound.play()
	collision.set_deferred("disabled", true)
	sprite.visible = false
	target = null
	return experience

func _on_sound_collected_finished() -> void:
	queue_free()

extends Area2D

signal damage(dmg : int)

func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred("set", "disabled", false)

func _on_body_entered(body: Node2D) -> void:
	damage.emit(1)
	$CollisionShape2D.call_deferred("set", "disabled", true)
	$DisableTimer.start()

extends Area2D

signal damage(dmg : int)

func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred("set", "disabled", false)

func _on_area_entered() -> void:
	emit_signal("damage", damage)
	$CollisionShape2D.call_deferred("set", "disabled", true)
	$DisableTimer.start()

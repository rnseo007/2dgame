extends Area2D

signal get_damage(dmg : int)

func _on_disable_timer_timeout() -> void:
	$HitBox.call_deferred("set", "disabled", false)

func _on_body_entered(_body: Node2D) -> void:
	get_damage.emit(1)
	$HitBox.call_deferred("set", "disabled", true)
	$DisableTimer.start()

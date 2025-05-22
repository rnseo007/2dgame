extends Area2D

signal get_damage(dmg : int)

func _on_area_entered(area) -> void:
	if area.is_in_group("Player_Bullet"):
		if not area.get("damage") == null:
			get_damage.emit(area.get("damage"))

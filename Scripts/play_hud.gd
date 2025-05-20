extends CanvasLayer


func _on_player_player_cur_hp(hp: int) -> void:
	$Hp.text = "HP: {0}".format({0:hp})

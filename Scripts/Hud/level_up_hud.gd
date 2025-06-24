extends CanvasLayer

var up_box = preload("res://Scenes/HUD_Scenes/up_box.tscn")

var card_texture = {
	"gold" : preload("res://assets/Card/card frames/base 5.png"),
	"iron" : preload("res://assets/Card/card frames/base 11.png"),
	"bronze" : preload("res://assets/Card/card frames/base 23.png")
}

func _ready() -> void:
	for i in range(-1, 2):
		var new_up_box = up_box.instantiate()
		new_up_box.position.x += 327.0 * i
		new_up_box.card_texture = card_texture.get("gold")
		add_child(new_up_box)
		print("Generated! : ", i, " / position :" , new_up_box.position)

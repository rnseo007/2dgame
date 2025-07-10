extends Control

@onready var up_box = preload("res://Scenes/HUD_Scenes/up_box.tscn")
@onready var h_container = $HBoxContainer

var card_texture = {
	"gold" : preload("res://assets/Card/card frames/base 5.png"),
	"iron" : preload("res://assets/Card/card frames/base 11.png"),
	"bronze" : preload("res://assets/Card/card frames/base 23.png")
}

func _ready() -> void:
	for i in range(0, 3):
		var new_up_box = up_box.instantiate()
		new_up_box.card_texture = card_texture.get("gold")
		new_up_box.card_name = "Test %d" % [i]
		h_container.call_deferred("add_child", new_up_box)
		new_up_box.clicked.connect(Callable(self, "_on_card_clicked").bind(new_up_box))
		#print("Generated! : ", i, " / position :" , new_up_box.position)

func _on_card_clicked(item) -> void:
	print(item.card_name)
	get_parent().get_tree().paused = false
	queue_free()
	pass

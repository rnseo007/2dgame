extends Control

@onready var card = preload("res://hud/scenes/inv_card.tscn")
@onready var gird_container = $ScrollContainer/MarginContainer/GridContainer
@onready var text_display = $Card_text
@onready var display_picked_card : Array = [$FusioGround/MarginContainer/HBoxContainer/PickedCard1, $FusioGround/MarginContainer/HBoxContainer/PickedCard2]

#inv_card_list = card_list keys
var inv_card_list : Array = []
var card_list

func _ready() -> void:
	var card_count : int = inv_card_list.size()
	for i in range(0, card_count):
		var new_card = card.instantiate()
		new_card.card_texture = card_list.get(inv_card_list.get(i)).card_texture
		new_card.id = i
		gird_container.call_deferred("add_child", new_card)
		new_card.clicked.connect(Callable(self, "_on_card_clicked").bind(new_card))
	text_display.text = "CARD : %d" % [card_count]

func _on_card_clicked(item):
	for i in range(0, display_picked_card.size()):
		print(i)
		if display_picked_card[i].texture == null:
			display_picked_card[i].texture = item.card_texture
			display_picked_card[i].get_id = item.id
			display_picked_card[i]._get_new_card()
			break

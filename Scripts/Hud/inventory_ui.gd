extends Control

@onready var card = preload("res://Scenes/HUD_Scenes/inv_card.tscn")
@onready var gird_container = $ScrollContainer/MarginContainer/GridContainer
@onready var text_display = $card_text

var inv_card_list : Array = []
var card_list

func _ready() -> void:
	var card_count : int = inv_card_list.size()
	for i in range(0, card_count):
		var new_card = card.instantiate()
		new_card.card_texture = card_list.get(inv_card_list.get(i)).card_texture
		gird_container.call_deferred("add_child", new_card)
	text_display.text = "CARD : %d" % [card_count]

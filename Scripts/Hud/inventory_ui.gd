extends Control

@onready var card = preload("res://Scenes/HUD_Scenes/inv_card.tscn")
@onready var gird_container = $ScrollContainer/MarginContainer/GridContainer
@onready var text_display = $Card_text
@onready var fusio_container = $FusioGround/MarginContainer/HBoxContainer

#inv_card_list = card_list keys
var inv_card_list : Array = []
var card_list

var picked_card : Array = []

func _ready() -> void:
	var card_count : int = inv_card_list.size()
	for i in range(0, card_count):
		var new_card = card.instantiate()
		new_card.card_texture = card_list.get(inv_card_list.get(i)).card_texture
		new_card.card_name = inv_card_list.get(i)
		gird_container.call_deferred("add_child", new_card)
		new_card.clicked.connect(Callable(self, "_on_card_clicked").bind(new_card))
	text_display.text = "CARD : %d" % [card_count]

func _on_card_clicked(item):
	print("clicked : ", item)
	if picked_card.size() >= 2:
		return
	#if picked_card.size() == 1:
		#fusio_container.add_spacer()
	var picked_new_card = card.instantiate()
	picked_new_card.card_texture = card_list.get(item.card_name).card_texture
	picked_new_card.custom_minimum_size = picked_new_card.get_minimum_size() * 1.5
	picked_new_card.size = picked_new_card.custom_minimum_size
	picked_new_card.pivot_offset = picked_new_card.size / 2
	
	fusio_container.add_child(picked_new_card)
	picked_card.append(item)

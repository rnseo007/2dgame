extends Control

@onready var card = preload("res://hud/scenes/inv_card.tscn")
@onready var gird_container = $ScrollContainer/MarginContainer/GridContainer
@onready var text_display = $Card_text
@onready var display_picked_card : Array = [$FusioGround/MarginContainer/HBoxContainer/PickedCard1, $FusioGround/MarginContainer/HBoxContainer/PickedCard2]
@onready var out_button = $Out_Button

#inv_card_list = card_list keys
var inv_card_list : Array = []
var card_list

func _ready() -> void:
	var card_count : int = inv_card_list.size()
	var i = 0
	for card_key in inv_card_list:
		var new_card = card.instantiate()
		new_card.card_texture = card_list.get(card_key).icon
		new_card.id = i
		gird_container.call_deferred("add_child", new_card)
		new_card.clicked.connect(Callable(self, "_on_card_clicked").bind(new_card))
		i += 1
	text_display.text = "CARD : %d" % [card_count]
	out_button.pressed.connect(_on_out_button_press)
	
	if not get_tree().paused:
		get_tree().paused = true

func _on_card_clicked(item):
	for i in range(0, display_picked_card.size()):
		print(i)
		if display_picked_card[i].texture == null:
			display_picked_card[i].texture = item.card_texture
			display_picked_card[i].get_id = item.id
			display_picked_card[i]._get_new_card()
			break

func _on_out_button_press():
	get_tree().paused = false
	queue_free()

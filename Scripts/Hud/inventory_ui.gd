extends Control

@onready var card = preload("res://Scenes/HUD_Scenes/inv_card.tscn")
@onready var gird_container = $ScrollContainer/MarginContainer/GridContainer
@onready var text_display = $card_text

func _ready() -> void:
	for i in range(0, 23):
		var new_card = card.instantiate()
		gird_container.call_deferred("add_child", new_card)
	text_display.text = "CARD : %d" % [23]

extends Node2D

@export var card_list : Array[CardList] = []

@onready var attack = get_tree().root.get_node("Main/Attack")

func get_card():
	pass

func cards_set_up():
	if card_list.size() > 1:
		pass

extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var card = get_tree().root.get_node("Main/Attack")
@onready var hp_label = $Hp
@onready var card_label = $Card
@onready var xp_progress_bar = $Xp_bar
@onready var level_label = $Xp_bar/Level

func _process(_delta: float) -> void:
	hp_label.text = "HP : {0}".format({0:player.hp})
	card_label.text = "CARD : %03d / %03d" % [card.cur_ammo, card.max_ammo]
	xp_progress_bar.max_value = player.max_xp
	xp_progress_bar.value = player.cur_xp
	level_label.text = "LEVEL : %d" % [player.level]

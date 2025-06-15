extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var card = get_tree().root.get_node("Main/Attack")
@onready var hp_label = $Hp
@onready var card_label = $Card
@onready var xp_progress_bar = $Xp_bar
@onready var level_label = $Xp_bar/Level

var card_count : int = 6 #card count

var card_list : Array = []

var inv_end_x = 388.0
var inv_start_x = 986.0


var inv_card_texture = {
	"blank" = preload("res://assets/Card/Cards/blankcard.png"),
	"fire_bolt" = preload("res://assets/Card/Cards/firecard.png")
}

func _process(_delta: float) -> void:
	hp_label.text = "HP : {0}".format({0:player.hp})
	card_label.text = "CARD : %03d / %03d" % [card.cur_ammo, card.max_ammo]
	xp_progress_bar.max_value = player.max_xp
	xp_progress_bar.value = player.cur_xp
	level_label.text = "LEVEL : %d" % [player.level]


func _on_attack_reload_card(cardlist: Array) -> void:
	card_list = cardlist
	card_count = cardlist.size()
	var interval = (inv_end_x - inv_start_x) / float(card_count - 1)
	for i in range(0, card_count):
		var new_card_base = TextureRect.new()
		new_card_base.texture = inv_card_texture.get(cardlist.get(i))
		new_card_base.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		new_card_base.position.y = 510.0
		new_card_base.position.x = inv_start_x - interval * i
		add_child(new_card_base)

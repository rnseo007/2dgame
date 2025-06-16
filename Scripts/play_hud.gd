extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var attack = get_tree().root.get_node("Main/Attack")
@onready var hp_label = $Hp
@onready var card_label = $Card
@onready var xp_progress_bar = $Xp_bar
@onready var level_label = $Xp_bar/Level

var inv_end_x = 388.0
var inv_start_x = 986.0

var cur_cards : Array = []

var inv_card_texture = {
	"blank" : preload("res://assets/Card/Cards/blankcard.png"),
	"fire_bolt" : preload("res://assets/Card/Cards/firecard.png")
}

func _process(_delta: float) -> void:
	hp_label.text = "HP : {0}".format({0:player.hp})
	card_label.text = "CARD : %03d / %03d" % [attack.cur_ammo, attack.max_ammo]
	xp_progress_bar.max_value = player.max_xp
	xp_progress_bar.value = player.cur_xp
	level_label.text = "LEVEL : %d" % [player.level]

func _on_attack_reload_card() -> void:
	var card_list : Array = attack.cur_card_list
	var card_count : int = card_list.size()
	var interval : float = 50.0
	if inv_start_x - interval * card_count < inv_end_x:
		interval = (inv_start_x - inv_end_x) / float(card_count - 1)
	
	#print("Card list : ", card_list, "/ Card Count : ", card_count)
	#print("interval = ", interval)
	
	for i in range(0, card_count):
		var new_card_base = TextureRect.new()
		
		new_card_base.texture = inv_card_texture.get(card_list.get(i))
		new_card_base.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		new_card_base.size = Vector2(150.0, 150.0)
		new_card_base.position.y = 510.0
		new_card_base.position.x = 1090.0 #inv_start_x - interval * i
		new_card_base.pivot_offset = new_card_base.size / 2.0
		new_card_base.scale = Vector2(0.5, 0.5)
		
		add_child(new_card_base)
		cur_cards.append(new_card_base)
		
		var duration = attack.reload_time / attack.max_ammo
		var tween = get_tree().create_tween()
		tween.tween_property(new_card_base, "position", Vector2(inv_start_x - interval * i, 510.0), duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(new_card_base, "scale", Vector2(1.0, 1.0), duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		#print(attack.reload_time / attack.max_ammo)
		await get_tree().create_timer(duration).timeout
	print(cur_cards.size())

func _on_attack_shooted() -> void:
	#print("shooted")
	cur_cards[cur_cards.size()-1].queue_free()
	cur_cards.pop_back()

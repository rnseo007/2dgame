extends CanvasLayer

@onready var card_list = preload("res://card_system/data/total_data/card_list.tres")

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var attack = get_tree().root.get_node("Main/Attack")
@onready var level_up_hud = preload("res://hud/scenes/level_up_hud.tscn")
@onready var inventory_ui = preload("res://hud/scenes/inventory_ui.tscn")
@onready var inventory_icon = $InvenIcon
@onready var hp_label = $Hp
@onready var card_label = $Card
@onready var xp_progress_rect = $Xp/XpRect
@onready var xp_progress_level = $Xp/Level
@onready var xp_progress_percent = $Xp/Percent
@onready var xp_progress_rect_mat = $Xp/XpRect.material #shader material
@onready var hand = $HandCardsDisplay

#패 display position
var inv_end_x = 388.0
var inv_start_x = 900.0

#current cards array
var cur_cards : Array = []

#level up hud
var pending_levelups: int = 0
var processing_levelups: bool = false

func _ready() -> void:
	player.levelup.connect(level_up)
	attack.reload_card.connect(_on_attack_reload_card)
	attack.shooted.connect(_on_attack_shooted)
	inventory_icon.clicked.connect(_pop_up_inventory)

#player call -> level up function
func level_up(count : int):
	#레벨업 오류 방지
	if count <= 0:
		return
	#레벨업 횟수 입력
	pending_levelups += count
	#레벨업 중이 아닐 때 레벨업 프로세스 진행
	if not processing_levelups:
		_process_level_ups()


func _process_level_ups() -> void:
	#레벨업 프로세스 진행중 표기
	processing_levelups = true
	
	#레벨업 연출 준비
	_set_xp_glow(true)
	_set_xp_full_visuals()
	
	#pause
	if not get_tree().paused:
		get_tree().paused = true
	
	while pending_levelups > 0:
		var new_level_up_hud := level_up_hud.instantiate()
		add_child(new_level_up_hud)
		
		pending_levelups -= 1
		await new_level_up_hud.closed
	
	#마무리 정리
	_set_xp_glow(false)
	get_tree().paused = false
	processing_levelups = false
	update_hud()

func _set_xp_glow(switch : bool) -> void:
	#glow 온오프
	xp_progress_rect_mat.set_shader_parameter("is_glowing", switch)

func _set_xp_full_visuals() -> void:
	animate_xp_bar(1.0)
	#xp_progress_rect.scale.x = 1.0
	xp_progress_percent.text = "100%"

#display update
func update_hud() -> void:
	#hp
	hp_label.text = "HP : %d" % [player.hp]
	#카드 현재 탄약 / 최대 탄약
	card_label.text = "CARD : %03d / %03d" % [attack.cur_ammo, attack.max_ammo]
	
	var denom : float = float(max(1, player.max_xp)) #0 나눗셈 방지
	var xp_ratio : float = clamp(float(player.cur_xp) / denom, 0.0, 1.0) #0~1 사이값 가질 수 있도록 제한
	
	#진행도 표시
	animate_xp_bar(xp_ratio)
	#xp_progress_rect.scale.x = xp_ratio
	#레벨 표기
	xp_progress_level.text = "LEVEL : %d" % [player.level]
	
	#퍼센트 표기
	var percent := int(xp_ratio * 100)
	xp_progress_percent.text = "%d%%" % [percent]

func animate_xp_bar(target_ratio:float, duration:float = 0.1) -> void:
	var clamped_ratio = clamp(target_ratio, 0.0, 1.0)
	var tween = xp_progress_rect.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(xp_progress_rect, "scale:x", clamped_ratio, duration)

func _process(_delta: float) -> void:
	update_hud()

#attack node call(reload_card)
#cur_card_list = inv_card_list array's key
func _on_attack_reload_card() -> void:
	#attack의 cur_card_list 는 리스트 키 값만 가지고 있음
	var card_list_keys : Array = attack.cur_card_list
	var card_count : int = card_list_keys.size()
	#카드 간격
	var interval : float = 50.0
	var duration : float = attack.reload_time / attack.max_ammo
	if inv_start_x - interval * card_count < inv_end_x:
		interval = (inv_start_x - inv_end_x) / float(card_count - 1)
	
	for i in range(0, card_count):
		var new_card_base = TextureRect.new()
		new_card_base.texture = card_list.card_list_data.get(card_list_keys.get(i)).icon
		new_card_base.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		new_card_base.size = Vector2(100.0, 150.0)
		new_card_base.position.y = 510.0
		new_card_base.position.x = 1090.0 #inv_start_x - interval * i
		new_card_base.pivot_offset = new_card_base.size / 2.0
		new_card_base.scale = Vector2(0.9, 0.9)
		
		hand.add_child(new_card_base)
		cur_cards.append(new_card_base)
		
		#print(duration, "> ", duration*i, " : ", attack.reload_time)
		var tween = get_tree().create_tween()
		tween.tween_interval(duration*i)
		if i > 0:
			tween.tween_property(new_card_base, "position", Vector2(inv_start_x - interval * i, 510.0), duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).finished.connect(Callable(self, "_on_prev_card_darken").bind(cur_cards[i-1]))
		else:
			tween.tween_property(new_card_base, "position", Vector2(inv_start_x - interval * i, 510.0), duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(new_card_base, "scale", Vector2(1.0, 1.0), duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_prev_card_darken(card):
	if is_instance_valid(card):
		var tween = get_tree().create_tween()
		tween.tween_property(card, "modulate", Color(0.5,0.5,0.5), 0.1)

func _on_attack_shooted() -> void:
	var used_card = cur_cards[cur_cards.size()-1]
	cur_cards.erase(used_card)
	if cur_cards.size() > 0:
		cur_cards[cur_cards.size()-1].modulate = Color(1,1,1)
	
	var tween = get_tree().create_tween()
	tween.tween_property(used_card, "position", Vector2(used_card.position.x, used_card.position.y - 50), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(used_card, "modulate", Color(1, 1, 1, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.finished.connect(Callable(self, "_on_card_tween_finished").bind(used_card))

func _on_card_tween_finished(uc):
	if is_instance_valid(uc):
		uc.queue_free()

#inventory pop up
func _pop_up_inventory() -> void:
	var new_inventory = inventory_ui.instantiate()
	new_inventory.inv_card_list = attack.inv_card_list
	new_inventory.card_list = card_list.card_list_data
	add_child(new_inventory)

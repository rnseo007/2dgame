extends Control

@onready var up_box = preload("res://hud/scenes/up_box.tscn")
@onready var h_container = $HBoxContainer
var attack

@export var upbox_list : Dictionary[String, Resource]

func _ready() -> void:
	var active_list : Array
	for i in range(0,3):
		var upbox_key = upbox_list.keys().pick_random()
		var upbox_upgrade = upbox_list[upbox_key].upgrade_list
		var upbox_upgrade_key = upbox_upgrade.keys().pick_random()
		if active_list.has(upbox_upgrade_key):
			i-=1
			continue
		active_list.append(upbox_upgrade_key)
		var cur_upgrade = upbox_upgrade[upbox_upgrade_key]
		
		var new_up_box = up_box.instantiate()
		new_up_box.card_texture = upbox_list[upbox_key].icon
		new_up_box.card_name = cur_upgrade.name
		new_up_box.card_descript = cur_upgrade.description
		new_up_box.value = randi_range(5,20)
		h_container.call_deferred("add_child", new_up_box)
		new_up_box.clicked.connect(Callable(self, "_on_card_clicked").bind(new_up_box))
		#print("Generated! : ", i, " / position :" , new_up_box.position)

func _on_card_clicked(item) -> void:
	print(item.card_name)
	get_parent().get_tree().paused = false
	queue_free()
	pass

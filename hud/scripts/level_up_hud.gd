extends Control

signal closed

@onready var up_box = preload("res://hud/scenes/up_box.tscn")
@onready var h_container = $HBoxContainer

@export var upbox_list : Dictionary[String, Resource]

func _ready() -> void:
	var active_list : Array
	var i : int = 0
	while i < 3:
		var upbox_key = upbox_list.keys().pick_random()
		var upbox_upgrade = upbox_list[upbox_key].upgrade_list
		var upbox_upgrade_key = upbox_upgrade.keys().pick_random()
		if active_list.has(upbox_upgrade_key):
			continue
		active_list.append(upbox_upgrade_key)
		print(active_list)
		var cur_upgrade = upbox_upgrade[upbox_upgrade_key]
		
		var new_up_box = up_box.instantiate()
		new_up_box.card_texture = upbox_list[upbox_key].icon
		new_up_box.card_name = cur_upgrade.name
		new_up_box.card_descript = cur_upgrade.description
		new_up_box.value = randi_range(5,20)
		h_container.call_deferred("add_child", new_up_box)
		new_up_box.clicked.connect(Callable(self, "_on_card_clicked").bind(new_up_box))
		i += 1

func _on_card_clicked(item) -> void:
	print(item.card_name)
	closed.emit()
	queue_free()
	pass

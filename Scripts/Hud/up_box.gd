extends TextureRect

var orignal_scale : Vector2 = Vector2(1, 1)
var highlight_scale : Vector2 = Vector2(1.2, 1.2)
var tween_duration : float = 0.05

@onready var area2d = $Area2D
@onready var name_label = $NameText
@onready var descript_label = $DescriptText

var card_name : String = "<NAME>"
var card_descript : String = "<descript>"

var card_texture = preload("res://assets/Card/card frames/base 8.png")

func _ready() -> void:
	scale = orignal_scale
	texture = card_texture
	
	name_label.text = card_name
	descript_label.text = card_descript
	
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", highlight_scale, tween_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	material.set_shader_parameter("outline_enabled", true)
func _on_mouse_exited() -> void:
	print("out", self)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", orignal_scale, tween_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	material.set_shader_parameter("outline_enabled", false)

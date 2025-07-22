extends TextureRect

signal clicked

@onready var area2d = $Area2D
@onready var name_label = $NameText
@onready var descript_label = $DescriptText
@onready var anim = $AnimationPlayer

var card_name : String = "<NAME>"
var card_descript : String = "<descript>"

var card_texture = preload("res://assets/Card/card frames/base 8.png")

func _ready() -> void:
	texture = card_texture
	
	name_label.text = card_name
	descript_label.text = card_descript
	
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	anim.play("Highlight")
	material.set_shader_parameter("outline_enabled", true)
func _on_mouse_exited() -> void:
	anim.play("DeHighlight")
	material.set_shader_parameter("outline_enabled", false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit()

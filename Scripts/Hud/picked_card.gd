extends TextureRect

@onready var area2d = $Area2D
@onready var anim = $AnimationPlayer
@onready var collision2d = $Area2D/CollisionShape2D

var get_id : int

func _ready() -> void:
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	collision2d.disabled = true

func _on_mouse_entered() -> void:
	anim.play("Highlight")
	material.set_shader_parameter("outline_enabled", true)
func _on_mouse_exited() -> void:
	anim.play("DeHighlight")
	material.set_shader_parameter("outline_enabled", false)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_lost_card()

func _get_new_card():
	mouse_filter = Control.MOUSE_FILTER_PASS
	collision2d.disabled = false
	anim.play("GetNewCard")

func _lost_card():
	texture = null
	get_id = -1
	anim.play("LostCard")
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	collision2d.disabled = true

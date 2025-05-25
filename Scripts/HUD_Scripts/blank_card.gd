extends Area2D

var highlight : bool = false
var base_size : float = 1.0
var cur_size : float = 1.0
var highlight_size : float = 1.3

func _process(delta: float) -> void:
	if highlight:
		size_up(delta)
	else:
		size_down(delta)
	scale = Vector2(cur_size, cur_size)

func size_up(delta):
	if cur_size < highlight_size:
		cur_size += 1 * delta
	elif cur_size >= highlight_size:
		cur_size = highlight_size

func size_down(delta):
	if cur_size > base_size:
		cur_size -= 1 * delta
	elif cur_size <= base_size:
		cur_size = base_size

func _on_mouse_entered() -> void:
	highlight = true
	

func _on_mouse_exited() -> void:
	highlight = false

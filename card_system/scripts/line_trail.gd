extends Line2D

var max_point : int = 30 #line length

func _ready():
	clear_points()

func _process(_delta):
	add_point(to_local(get_parent().global_position))
	
	if get_point_count() > max_point:
		remove_point(0)

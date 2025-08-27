extends Node
class_name WorldGen

@export var map_size : int = 20
@export var chunk_size : int = 100
@export var world_scale : float = 100.0

#RNG
var rng := RandomNumberGenerator.new()

func generate(r_seed : int = 0):
	#reset
	if r_seed != 0:
		rng.seed = r_seed
	else:
		rng.randomize()
	print("SEED :", rng.seed)
	
	var rooms : Array

func generate_room(prev_entered_dir, world_pos : Vector2i) -> Array:
	#방 크기 설정
	var width = rng.randi_range(5, 30)
	var height = rng.randi_range(5, 30)
	
	#최소 크기 보정 min(5x10 or 10x5)
	if width < 10 and height < 10:
		if width < height:
			width = 5
			height = max(10, height)
		else:
			width = max(10, width)
			height = 5
	#width, height -> vector2i 변환
	var room_size : Vector2i = Vector2i(width, height)
	
	#빈 방 제작 후 저장
	var room_grid = _create_empty_room(room_size)
	
	#방에 벽 생성
	room_grid = _create_walls(room_grid, room_size)
	
	#출구 갯수 설정
	var exit_count = rng.randi_range(1, 3)
	#출구 방위
	var dirs : Array = ["N", "E", "S", "W"]
	
	#들어온 경로를 제거
	if prev_entered_dir != null:
		dirs.erase(prev_entered_dir)
	
	#출구 경로 랜덤 선택
	var exit_dirs = _random_exit_dir(dirs, exit_count)
	
	#출구 배치
	for dir in exit_dirs:
		var exit_pos = _place_exit_in_wall(room_size, dir)
		if exit_pos != null:
			if room_grid[exit_pos.x][exit_pos.y] == 1:
				room_grid[exit_pos.x][exit_pos.y] = 2
	
	return room_grid

func _create_empty_room(room_size : Vector2i) -> Array:
	var grid = _make_grid(room_size)
	return grid

func _create_walls(room_grid : Array, room_size : Vector2i) -> Array:
	for y in range(0, room_size.y):
		for x in range(0, room_size.x):
			if x == 0 or x == room_size.x - 1:
				room_grid[y][x] = 1
			elif y == 0 or y == room_size.y - 1:
				room_grid[y][x] = 1
	return room_grid

func _random_exit_dir(dirs : Array, exit_count) -> Array:
	dirs.shuffle()
	dirs.resize(exit_count)
	return dirs

func _place_exit_in_wall(room_size : Vector2i, dir):
	if dir == null:
		return null
	var exit_pos : Vector2i
	match dir:
		"N":
			exit_pos = Vector2i(0, _random_exit_pos(room_size.x))
		"E":
			exit_pos = Vector2i(_random_exit_pos(room_size.y), room_size.x - 1)
		"S":
			exit_pos = Vector2i(room_size.y - 1, _random_exit_pos(room_size.x))
		"W":
			exit_pos = Vector2i(_random_exit_pos(room_size.y), 0)
	return exit_pos

func _random_exit_pos(room_size : int) -> int:
	#최대 사이즈-2 후 좌표값으로 변환
	var _pos = rng.randi_range(0, room_size - 3) + 1
	return _pos


func _make_grid(size: Vector2i) -> Array:
	var g := []
	g.resize(size.y)
	for y in size.y:
		g[y] = []
		g[y].resize(size.x)
		for x in size.x:
			g[y][x] = 0
	return g

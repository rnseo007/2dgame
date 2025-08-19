extends Node
class_name WorldGenBSP

# -------------------
# public parameters
# -------------------
@export var map_size : Vector2i = Vector2i(100, 100)
@export var min_leaf_size : Vector2i = Vector2i(12, 10) # 제일 작은 쪼개기 크기 (더 작으면 안 쪼개짐)
@export var min_room_size : Vector2i = Vector2i(6, 5) # 최소 방 크기
@export var max_depth : int = 8 # 분할 최대 깊이 (밀도 조절)
@export var corridor_width : int = 1 # 복도 폭

const WALL := 0
const FLOOR := 1

const INVALID_V2I := Vector2i(-1, -1)

# -------------------
# Internal types(내부 유형)
# -------------------
class Leaf:
	var rect : Rect2i
	var left : Leaf = null
	var right : Leaf = null
	var room : Rect2i = Rect2i() # size=(0,0) 이면 없음
	
	func _init(r : Rect2i) -> void:
		rect = r

# --------------------
# RNG
# --------------------
var rng := RandomNumberGenerator.new()

# --------------------
# API
# --------------------
func generate(rseed : int = 0) -> Array:
	# 1) 초기화
	if rseed != 0:
		rng.seed = rseed
	else:
		rng.randomize()
	
	var grid := _make_grid(map_size, WALL)
	
	#2)BSP 분할 트리 만들기
	var root := Leaf.new(Rect2i(Vector2i.ZERO, map_size))
	_build_bsp(root, 0)
	
	#3) 리프에 방 생성
	_create_rooms(root)
	
	#4) 형제 간 복도 연결
	_connect_siblings(root, grid)
	
	#5) 그리드에 방/복도 조각
	_carve_rooms(root, grid)
	
	#6) 가장자리 마감: 외각은 벽 유지
	return grid

# ---------------------
# BSP buliding
# ---------------------
func _build_bsp(leaf : Leaf, depth : int) -> void:
	if depth >= max_depth:
		return
	# 더 쪼갤 수 없으면 종료
	if not _try_split(leaf):
		return
	#재귀
	_build_bsp(leaf.left, depth + 1)
	_build_bsp(leaf.right, depth + 1)

func _try_split(leaf : Leaf) -> bool:
	#이미 분할되었으면 X
	if leaf.left or leaf.right:
		return false
	
	# 최소 사이즈 * 2 이면 분할 가능
	var can_split_h := leaf.rect.size.y >= (min_leaf_size.y * 2)
	var can_split_v := leaf.rect.size.x >= (min_leaf_size.x * 2)
	# 둘 다 불가능하면 분할 X
	if not can_split_h and not can_split_v:
		return false
	
	#분할 축 선택
	var split_h := false
	if can_split_h and can_split_v:
		#가로/세로 무작위 선택. 직사각형 비율을 고려해 편향해도 좋음.
		split_h = rng.randi() % 2 == 0
	elif can_split_h:
		split_h = true
	else:
		split_h = false
	
	#y축 분할
	if split_h:
		var min_y := min_leaf_size.y
		var max_y := leaf.rect.size.y - min_leaf_size.y
		if max_y <= min_y:
			return false
		var split_y := rng.randi_range(min_y, max_y)
		var top := Rect2i(leaf.rect.position, Vector2i(leaf.rect.size.x, split_y))
		var bottom := Rect2i(leaf.rect.position + Vector2i(0, split_y), Vector2i(leaf.rect.size.x, leaf.rect.size.y - split_y))
		leaf.left = Leaf.new(top)
		leaf.right = Leaf.new(bottom)
	#x축 분할
	else:
		var min_x := min_leaf_size.x
		var max_x := leaf.rect.size.x - min_leaf_size.x
		if max_x <= min_x:
			return false
		var split_x := rng.randi_range(min_x, max_x)
		var left_rect := Rect2i(leaf.rect.position, Vector2i(split_x, leaf.rect.size.y))
		var right_rect := Rect2i(leaf.rect.position + Vector2i(split_x, 0), Vector2i(leaf.rect.size.x - split_x, leaf.rect.size.y))
		leaf.left = Leaf.new(left_rect)
		leaf.right = Leaf.new(right_rect)
	
	return true

# -----------------
# 방 제작
# -----------------
func _create_rooms(leaf : Leaf) -> void:
	#다 나눠졌다면 진행
	if leaf.left == null and leaf.right == null:
		# 리프 박스 내부에 여유를 두고 방을 랜덤 배치
		var margin := Vector2i(1, 1) #벽 배치용 여백
		var max_room := leaf.rect.size - margin * 2 # 현재 rect에서 가질 수 있는 최대 방 크기
		# 너무 작은 방 생성 방지
		if max_room.x < min_room_size.x or max_room.y < min_room_size.y:
			return
		var room_w := rng.randi_range(min_room_size.x, max_room.x)
		var room_h := rng.randi_range(min_room_size.y, max_room.y)
		var room_x := leaf.rect.position.x + rng.randi_range(margin.x, leaf.rect.size.x - room_w - margin.x)
		var room_y := leaf.rect.position.y + rng.randi_range(margin.y, leaf.rect.size.y - room_h - margin.y)
		leaf.room = Rect2i(Vector2i(room_x, room_y), Vector2i(room_w, room_h))
	else:
		if leaf.left:
			_create_rooms(leaf.left)
		if leaf.right:
			_create_rooms(leaf.right)

# -----------------------------------------------------
# Connect siblings (corridors) 형제 연결 (복도)
# -----------------------------------------------------
func _connect_siblings(leaf : Leaf, grid: Array) -> void:
	if leaf.left and leaf.right:
		var l := _get_any_room_center(leaf.left)
		var r := _get_any_room_center(leaf.right)
		
		if l != INVALID_V2I and r != INVALID_V2I:
			_carve_corridor(grid, l, r)
		#재귀
		_connect_siblings(leaf.left, grid)
		_connect_siblings(leaf.right, grid)

func _get_any_room_center(leaf: Leaf) -> Vector2i:
	#좌,우 둘 다 없다면(분할 완료됐다면) & 크기가 0이 아니라면
	if leaf.left == null and leaf.right == null and leaf.room.size != Vector2i.ZERO:
		return leaf.room.position + leaf.room.size / 2
	# 하위에서 아무 방이나 찾아서 반환(재귀)
	if leaf.left:
		var c := _get_any_room_center(leaf.left)
		if c != INVALID_V2I:
			return c
	
	if leaf.right:
		var d := _get_any_room_center(leaf.right)
		if d != INVALID_V2I:
			return d
	return INVALID_V2I

# -----------------------------
# Carving
# -----------------------------
func _carve_rooms(leaf : Leaf, grid : Array) -> void:
	if leaf.left == null and leaf.right == null:
		if leaf.room.size != Vector2i.ZERO:
			_rect_fill(grid, leaf.room, FLOOR)
	else:
		if leaf.left:
			_carve_rooms(leaf.left, grid)
		if leaf.right:
			_carve_rooms(leaf.right, grid)

func _carve_corridor(grid : Array, l : Vector2i, r : Vector2i) -> void:
	#L자 복도: 가로->세로 또는 세로->가로 로 무작위 선택
	var horizontal_first := rng.randi() % 2 == 0
	if horizontal_first:
		_hline(grid, l.x, r.x, l.y)
		_vline(grid, l.y, r.y, r.x)
	else:
		_vline(grid, l.y, r.y, l.x)
		_hline(grid, l.x, r.x, r.y)

#corridor width 지원
func _hline(grid: Array, x0: int, x1: int, y: int) -> void:
	if x0 > x1:
		var t := x0; x0 = x1; x1 = t
	for x in range(x0, x1 + 1):
		@warning_ignore("integer_division")
		for w in range(-int(corridor_width/2), corridor_width - int(corridor_width/2)):
			_set_floor(grid, Vector2i(x, y + w))

func _vline(grid: Array, y0: int, y1: int, x: int) -> void:
	if y0 > y1:
		var t := y0; y0 = y1; y1 = t
	for y in range(y0, y1 + 1):
		@warning_ignore("integer_division")
		for w in range(-int(corridor_width/2), corridor_width - int(corridor_width/2)):
			_set_floor(grid, Vector2i(x + w, y))

func _rect_fill(grid : Array, r : Rect2i, tile : int) -> void:
	for yy in range(r.position.y, r.position.y + r.size.y):
		for xx in range(r.position.x, r.position.x + r.size.x):
			if _in_bounds(Vector2i(xx, yy), map_size):
				grid[yy][xx] = tile

func _set_floor(grid: Array, p: Vector2i) -> void:
	if _in_bounds(p, map_size):
		grid[p.y][p.x] = FLOOR

# --------------------------
# Utils
# --------------------------
func _make_grid(size: Vector2i, fill: int) -> Array:
	var g := []
	g.resize(size.y)
	for y in size.y:
		g[y] = []
		g[y].resize(size.x)
		for x in size.x:
			g[y][x] = fill
	return g

func _in_bounds(p: Vector2i, size: Vector2i) -> bool:
	return p.x >= 0 and p.y >= 0 and p.x < size.x and p.y < size.y

extends Node
class_name BossRoomGenerator

enum BossType { CASTLE, CAVE, GRASS }

const CAVE_ID := 0
const CASTLE_ID := 1
const GRASS_FLOOR_ID := 2
const GRASS_WALL_ID := 3

func build_boss_room(tilemap: TileMap, top_left: Vector2i, size: Vector2i, boss_type: int) -> void:
	match boss_type:
		BossType.CASTLE:
			_build_rect_room(tilemap, top_left, size, CASTLE_ID, CASTLE_ID)
		BossType.CAVE:
			_build_rect_room(tilemap, top_left, size, CAVE_ID, CAVE_ID)
		BossType.GRASS:
			_build_rect_room(tilemap, top_left, size, GRASS_FLOOR_ID, GRASS_WALL_ID)

	# 내부 장식/기둥/트랩 예시(옵션)
	_add_simple_pillars(tilemap, top_left + Vector2i(3, 3), size - Vector2i(6, 6))

func _build_rect_room(tilemap: TileMap, pos: Vector2i, size: Vector2i, floor_id: int, wall_id: int) -> void:
	# 바닥 채우기
	for y in range(size.y):
		for x in range(size.x):
			tilemap.set_cell(0, pos + Vector2i(x, y), floor_id, Vector2i.ZERO)
	
	# 벽 테두리
	for x in range(size.x):
		tilemap.set_cell(1, pos + Vector2i(x, size.y - 1), wall_id, Vector2i.ZERO)
		tilemap.set_cell(1, pos + Vector2i(x, 0), wall_id, Vector2i.ZERO)
	for y in range(size.y):
		tilemap.set_cell(1, pos + Vector2i(0, y), wall_id, Vector2i.ZERO)
		tilemap.set_cell(1, pos + Vector2i(size.x - 1, y), wall_id, Vector2i.ZERO)

func _add_simple_pillars(tilemap: TileMap, pos: Vector2i, size: Vector2i) -> void:
	if size.x < 6 or size.y < 6:
		return
	var step := Vector2i(max(3, size.x / 3), max(3, size.y / 3))
	for y in range(pos.y + 1, pos.y + size.y - 1, step.y):
		for x in range(pos.x + 1, pos.x + size.x - 1, step.x):
			tilemap.set_cell(1, Vector2i(x, y), tilemap.get_cell_source_id(1, Vector2i(x, y)) if tilemap.get_cell_source_id(1, Vector2i(x, y)) != -1 else tilemap.get_cell_source_id(0, Vector2i(x, y)), Vector2i.ZERO)

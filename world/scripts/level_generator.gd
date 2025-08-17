extends Node2D
class_name LevelGenerator

@export var tilemap_path : NodePath
@export var boss_gate_scene : PackedScene
@export var global_seed : int = 123456

#허브/방/통로 파라미터
@export var hub_size : Vector2i = Vector2i(17, 17)
@export var boss_room_size : Vector2i = Vector2i(23, 17)
@export var boss_distance: int = 36
@export var corridor_width: int = 3
@export var corridor_gap_from_hub: int = 2

# 허브 타일셋(기본: 초원)
const GRASS_FLOOR_ID := 2
const GRASS_WALL_ID := 3

var _tilemap: TileMap
var _biome := BiomeManager.new()
var _boss_gen := BossRoomGenerator.new()

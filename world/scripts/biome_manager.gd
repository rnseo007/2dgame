extends Node
class_name BiomeManager

enum Biome {
	CAVE,
	CASTLE,
	GRASS
}

const CAVE_ID := 0
const CASTLE_ID := 1
const GRASS_FLOOR_ID := 2
const GRASS_WALL_ID := 3

func pick_biome(cx: int, cy: int, global_seed: int) -> int:
	var biome_count = 3
	return abs((cx * 73856093) ^ (cy * 19349663) ^ global_seed) % biome_count

func get_sources_for_biome(biome_id: int) -> Dictionary:
	match biome_id:
		Biome.CAVE:
			return { "floor": CAVE_ID,   "wall": CAVE_ID }
		Biome.CASTLE:
			return { "floor": CASTLE_ID, "wall": CASTLE_ID }
		Biome.GRASS:
			return { "floor": GRASS_FLOOR_ID, "wall": GRASS_WALL_ID }
		_:
			return { "floor": GRASS_FLOOR_ID, "wall": GRASS_WALL_ID }

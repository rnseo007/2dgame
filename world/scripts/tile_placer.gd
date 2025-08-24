extends Node
class_name TilePlacer

enum Biome{
	SNOW,
	PLAIN,
	DESERT,
	JUNGLE,
	OCEAN,
	HILL,
	HILL_SNOW
}

func print_to_tilemap(tile_layer: TileMapLayer, grid: Array, floor_coord: Vector2i, wall_coord: Vector2i) -> void:
	tile_layer.clear()
	
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			#var cell : int = grid[y][x]
			var height = grid[y][x][0]
			var moisture = grid[y][x][1]
			var tempurature = grid[y][x][2]
			
			var b = _set_biome(height, moisture, tempurature)
			var rect = ColorRect.new()
			match b:
				Biome.SNOW:
					rect.color = Color(1,1,1)
				Biome.PLAIN:
					rect.color = Color(0,1,0)
				Biome.DESERT:
					rect.color = Color(1.0, 0.817, 0)
				Biome.JUNGLE:
					rect.color = Color(0, 0.3, 0.055)
				Biome.OCEAN:
					rect.color = Color(0, 0, 1)
				Biome.HILL:
					rect.color = Color(0.3, 0.3, 0.3)
				Biome.HILL_SNOW:
					rect.color = Color(0.6, 0.6, 0.6)
				_:
					rect.color = Color(0, 0, 0)
			
			#rect.color = Color(height, moisture, tempurature)
			rect.size = Vector2(8, 8)
			rect.position = Vector2(x *8, y*8)
			tile_layer.add_child(rect)
			continue
			#if cell == 1:
				##floor tile
				#tile_layer.set_cell(Vector2i(x, y), 0, floor_coord)
			#if cell == 0:
				##wall tile
				#tile_layer.set_cell(Vector2i(x, y), 0, wall_coord)

func _set_biome(height, moisture, tempurature):
	if height > 0.7:
		if tempurature < 0.3:
			return Biome.HILL_SNOW
		else:
			return Biome.HILL
	elif tempurature > 0.5:
		if moisture < 0.3:
			return Biome.DESERT
		elif moisture > 0.6:
			return Biome.JUNGLE
		else:
			return Biome.PLAIN
	else:
		if tempurature < 0.3:
			return Biome.SNOW
		return Biome.OCEAN

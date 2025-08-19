extends Node
class_name TilePlacer

#tile_layer : TileMapLayer

static func print_to_tilemap(tile_layer: TileMapLayer, grid: Array, floor_coord: Vector2i, wall_coord: Vector2i) -> void:
	tile_layer.clear()
	
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			var cell : int = grid[y][x]
			if cell == 1:
				#floor tile
				tile_layer.set_cell(Vector2i(x, y), 0, floor_coord)
			if cell == 0:
				#wall tile
				tile_layer.set_cell(Vector2i(x, y), 0, wall_coord)

extends Node
class_name TilePlacer

func print_to_tilemap(grid: Array, floor_layer : TileMapLayer, wall_layer: TileMapLayer) -> void:
	floor_layer.clear()
	wall_layer.clear()
	
	var floor_cells : Array = []
	var wall_cells : Array = []
	for y in range(grid.size()):
		for x in range(grid[y].size()):
			var cell : int = grid[y][x]
			if cell == 0:
				#floor tile
				floor_cells.append(Vector2i(x, y))
			if cell == 1:
				#wall tile
				wall_cells.append(Vector2i(x, y))
			if cell == 2:
				#door tile
				wall_cells.append(Vector2i(x, y))
	
	floor_layer.set_cells_terrain_connect(floor_cells, 0, 0)
	wall_layer.set_cells_terrain_connect(wall_cells, 0, 0)

extends Node2D

var bsp = WorldGenBSP.new()

func _ready() -> void:
	var test := bsp.generate()
	#print(test)
	TilePlacer.print_to_tilemap($TileMapLayer, test, Vector2i(2,2), Vector2i(2,0))

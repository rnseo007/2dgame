extends Node2D

var bsp = WorldGenBSP.new()
var gen = WorldGen.new()
var tile_placer = TilePlacer.new()

func _ready() -> void:
	#var test := bsp.generate()
	var test := gen.generate()
	#print(test)
	tile_placer.print_to_tilemap($TileMapLayer2, test, Vector2i(2,2), Vector2i(2,0))

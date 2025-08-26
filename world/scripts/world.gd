extends Node2D

#var bsp = WorldGenBSP.new()
var gen = WorldGen.new()
var tile_placer = TilePlacer.new()

func _ready() -> void:
	#var test := bsp.generate()
	#var seed = gen.seed_set()
	var test = gen.generate_room(null)
	print(test)
	tile_placer.print_to_tilemap(test, $FLOOR, $WALL)

extends Node
class_name WorldGen

@export var map_size : int = 20
@export var chunk_size : int = 32
@export var world_scale : float = 100.0
var height_noise := FastNoiseLite.new()
var moisture_noise := FastNoiseLite.new()
var chuck_data := ChunkData.new()

#RNG
var rng := RandomNumberGenerator.new()

func generate(r_seed : int = 0):
	#reset
	if r_seed != 0:
		rng.seed = r_seed
	else:
		rng.randomize()
	print("SEED :", rng.seed)
	

func _generate_chunk(chunk : Vector2i):
	chuck_data.chunk = chunk
	
	
	#for y in range(chunk_size):

#여기 만들어야 됨.
func _make_grid():
	pass

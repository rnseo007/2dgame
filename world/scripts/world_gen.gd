extends Node
class_name WorldGen

@export var map_size : int = 20
@export var chunk_size : int = 100
@export var world_scale : float = 100.0
var height_noise := FastNoiseLite.new()
var moisture_noise := FastNoiseLite.new()
var temperature_noise := FastNoiseLite.new()

#RNG
var rng := RandomNumberGenerator.new()

func generate(r_seed : int = 0) -> Array:
	#reset
	if r_seed != 0:
		rng.seed = r_seed
	else:
		rng.randomize()
	print("SEED :", rng.seed)
	
	_set_noise_maps()
	
	var chunk = _generate_chunk(Vector2i(0,0))
	print("Chunk[0,0] 생성 완료: ", chunk.size(), " rows")
	return chunk

func _generate_chunk(chunk : Vector2i) -> Array:
	var chunk_data : Array = []
	for y in range(chunk_size):
		var row := []
		for x in range(chunk_size):
			#청크 내부 좌표 -> 전역 좌표
			var world_x = chunk.x * chunk_size + x
			var world_y = chunk.y * chunk_size + y
			
			#노이즈 값 평탄화(노말라이즈) [-1,1] -> [0,1]
			var h = (height_noise.get_noise_2d(world_x, world_y) + 1.0) * 0.5
			var m = (moisture_noise.get_noise_2d(world_x, world_y) + 1.0) * 0.5
			var t = (temperature_noise.get_noise_2d(world_x, world_y) + 1.0) * 0.5
			row.append([h, m, t])
		chunk_data.append(row)
	return chunk_data

func _set_noise_maps():
	#height map setup
	height_noise.seed = rng.seed
	height_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	height_noise.frequency = 0.1
	height_noise.fractal_octaves = 4
	height_noise.fractal_lacunarity = 2.0
	height_noise.fractal_gain = 0.5
	
	#moisture map setup
	moisture_noise.seed = (rng.seed + rng.seed) * 0.5
	moisture_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	moisture_noise.frequency = 0.05
	moisture_noise.fractal_octaves =  3
	
	#temperature map setup
	temperature_noise.seed = rng.seed - rng.seed/2
	temperature_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	temperature_noise.frequency = 0.02
	temperature_noise.fractal_octaves = 2

func _make_grid(size: Vector2i) -> Array:
	var g := []
	g.resize(size.y)
	for y in size.y:
		g[y] = []
		g[y].resize(size.x)
		for x in size.x:
			g[y][x] = 0
	return g

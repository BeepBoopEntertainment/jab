extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 256
var height = 256
#@onready var player = get_parent().get_child(1)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005


func _process(delta):
	generate_chunk(Vector2(1,1))
	

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var temp = temperature.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10
			var alt = abs(altitude.get_noise_2d(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)*10)
			var coord = Vector2i(tile_pos.x-width/2 + x, tile_pos.y-height/2 + y)
			# create enum mapping for Vector2 calls below.
			
			
			if alt < 2.5 and moist > 1:
				set_cell(0, coord, 0, Vector2(2,0))
			elif moist < 1:
				set_cell(0, coord, 1, Vector2(2,2))
			else:
				set_cell(0, coord, 1, Vector2(20,2))


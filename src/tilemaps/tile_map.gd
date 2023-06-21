extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 120
var height = 120

const LayerIds = {
	BASE = 0,
	OBJECT = 1
}

const SourceIds = {
	FARMLANDS = 0,
	WETLANDS  = 1
}
@onready var player = get_parent().get_child(0).get_child(0)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005


func _process(_delta):
	generate_chunk(player.position)


func map_environment_to_tile(alt: float, moist: float, temp: float):
	var source_id: int = SourceIds.FARMLANDS
	var at_coord: Vector2 = Vector2(1,1)
	if alt < -3 and moist > 4 and temp > -3:
		at_coord = Vector2(30,1)
		source_id = SourceIds.WETLANDS
	elif alt <= -3 and moist > 4 and temp <= -3:
		at_coord = Vector2(27,4)
		source_id = SourceIds.WETLANDS
	elif moist > 4 and temp > -3 and alt > -3:
		at_coord = Vector2(4,1)
		source_id = SourceIds.WETLANDS
	elif alt > -3 and moist <= 4 and temp > -3 and temp <= -1:
		at_coord = Vector2(2,0)
		source_id = SourceIds.FARMLANDS
	elif alt > -3 and moist <= 4 and temp > -1 and temp <= 0:
		at_coord = Vector2(3,0)
		source_id = SourceIds.FARMLANDS
	elif moist > 1 and temp > 2:
		at_coord = Vector2(0,0)
		source_id = SourceIds.FARMLANDS
	elif moist <= 1 and temp > 2:
		at_coord = Vector2(1,0)
		source_id = SourceIds.FARMLANDS
	else:
		at_coord = Vector2(4,1)
		source_id = SourceIds.WETLANDS
	
	return {
		coord  = at_coord,
		source = source_id
	}


func get_environment(tile_pos, x, y):
	var xnoise: int = tile_pos.x-width/2 + x
	var ynoise: int = tile_pos.y-height/2 + y
	var moist: float = moisture.get_noise_2d(xnoise, ynoise)*10
	var temp: float = temperature.get_noise_2d(xnoise, ynoise)*10
	var alt: float = altitude.get_noise_2d(xnoise, ynoise)*10
	
	return {
		alt   = alt,
		coord = Vector2i(xnoise, ynoise),
		moist = moist,
		temp  = temp
	}


func generate_chunk(player_position):
	var tile_pos = local_to_map(player_position)
	for x in range(width):
		for y in range(height):
			var environment = get_environment(tile_pos, x, y)
			var layer_id: int = LayerIds.BASE
			var tile = map_environment_to_tile(
				environment.alt,
				environment.moist,
				environment.temp
			)
				
			set_cell(layer_id, environment.coord, tile.source, tile.coord)


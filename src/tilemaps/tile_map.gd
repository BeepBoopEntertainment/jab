extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var trees = FastNoiseLite.new()
var width = 120
var height = 120

const LayerIds = {
	BASE = 0,
	OBJECT = 1
}


const SourceIds = {
	FARMLANDS = {
		"atlas_id": 2,
		"ground0": Vector2(2,0),
		"ground1": Vector2(3,0),
		"ground2": Vector2(5,0),
		"ground3": Vector2(6,0),
		"round_tree": Vector2(0,7)
	},
	DRYLANDS = {
		"atlas_id": 8,
		"ground0": Vector2(2,1),
		"ground1": Vector2(2,2),
		"ground2": Vector2(3,1),
		"ground3": Vector2(4,1)
	},
	WETLANDS = {
		"atlas_id": 8,
		"ground0": Vector2(27,1),
		"ground1": Vector2(30,1),
		"ground2": Vector2(27,4)
	},
	CAVE = {
		"atlas_id": 7,
		"ground0": Vector2(3,2),
		"ground1": Vector2(4,2),
		"ground2": Vector2(3,3),
		"ground3": Vector2(5,2)
	},
	WINTERLANDS = {
		"atlas_id": 9,
		"ground0": Vector2(0,1),
		"ground1": Vector2(0,0),
		"snowy_round_tree": Vector2(8,0),
		"pine_tree": Vector2(11,4),
		"snowy_pine_tree": Vector2(8,4),
		"snowy_rock": Vector2(1,0),
		"snowy_rock_big": Vector2(2,0)
	},
	UNDERWORLD = {
		"atlas_id": 6,
		"ground0": Vector2(12,3),
		"ground1": Vector2(13,3),
		"ground2": Vector2(14,3),
		"ground3": Vector2(12,4)
	}
}



@onready var player = get_parent().get_child(0).get_child(0)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005
	trees.seed = randi()
	trees.frequency = 0.1


func _process(_delta):
	generate_chunk(player.position)


func map_environment_to_tile(alt: float, moist: float, temp: float, tree: float):
	var source_id: int = SourceIds.FARMLANDS.atlas_id
	var at_coord: Vector2 = Vector2(1,1)
	
	
	if alt < -3 and moist > 4 and temp > -3:
		at_coord = SourceIds.WETLANDS["ground0"]
		source_id = SourceIds.WETLANDS.atlas_id
	elif alt <= -3 and moist > 4 and temp <= -3:
		at_coord = SourceIds.WETLANDS["ground1"]
		source_id = SourceIds.WETLANDS.atlas_id
	elif moist > 4 and temp > -3 and alt > -3:
		at_coord = SourceIds.DRYLANDS["ground0"]
		source_id = SourceIds.DRYLANDS.atlas_id
	elif alt > -3 and moist <= 4 and temp > -3 and temp <= -1:
		at_coord = SourceIds.FARMLANDS["ground0"]
		source_id = SourceIds.FARMLANDS.atlas_id
	elif alt > -3 and moist <= 4 and temp > -1 and temp <= 0:
		at_coord = SourceIds.FARMLANDS["ground1"]
		source_id = SourceIds.FARMLANDS.atlas_id
	elif moist > 1 and temp > 2:
		if tree > 4:
			at_coord = SourceIds.FARMLANDS["round_tree"]
		else:
			at_coord = SourceIds.FARMLANDS["ground2"]
		source_id = SourceIds.FARMLANDS.atlas_id
	elif moist <= 1 and temp > 2:
		at_coord = SourceIds.FARMLANDS["ground3"]
		source_id = SourceIds.FARMLANDS.atlas_id
	else:
		at_coord = SourceIds.DRYLANDS["ground1"]
		source_id = SourceIds.DRYLANDS.atlas_id
	
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
	var tree: float = trees.get_noise_2d(xnoise, ynoise)*10
	
	return {
		alt   = alt,
		coord = Vector2i(xnoise, ynoise),
		moist = moist,
		temp  = temp,
		tree = tree
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
				environment.temp,
				environment.tree
			)
				
			set_cell(layer_id, environment.coord, tile.source, tile.coord)


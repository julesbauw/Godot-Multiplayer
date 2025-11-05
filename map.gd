extends TileMap

class_name Map


var tile_list = [
	Vector2i(0,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(0,1),
	Vector2i(1,1),
	Vector2i(2,1),
]

func _ready() -> void:

	clear()

	for i in range(8):
		for j in range(8):
			set_cell(0,Vector2i(i,j),1,Vector2i(0,0))


#TODO network stuff

func place_tile(tile:int,pos:Vector2) -> void:
	
	var map_pos:Vector2i = local_to_map(pos)


	set_cell(0,map_pos,1,tile_list[tile])

func remove_tile(pos:Vector2) -> void:

	var map_pos:Vector2i = local_to_map(pos)

	erase_cell(0,map_pos)


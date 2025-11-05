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

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_map_info.connect(server_handle_map)
	ClientNetworkGlobals.handle_map_info.connect(client_handle_map)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_map_info.disconnect(server_handle_map)
	ClientNetworkGlobals.handle_map_info.disconnect(client_handle_map)

func _ready() -> void:

	clear()
	
	for i in range(8):
		for j in range(8):
			set_cell(0,Vector2i(i,j),1,Vector2i(0,0))


#TODO network stuff

func place_tile(tile:int,pos:Vector2) -> void:

	var map_pos:Vector2i = local_to_map(pos)

	MapInfo.create(map_pos,tile + 1).send(NetworkHandler.server_peer)

func remove_tile(pos:Vector2) -> void:

	var map_pos:Vector2i = local_to_map(pos)

	MapInfo.create(map_pos,0).send(NetworkHandler.server_peer)


func contains_tile(pos:Vector2) -> bool:
	# returns wether this position contains a tile or not
	var map_pos: Vector2i = local_to_map(pos)


	return get_cell_tile_data(0,map_pos) != null

# server updates  map and broadcasts
func server_handle_map(peer_id: int,map_info: MapInfo):

	var id = map_info.tile_id

	if (id == 0):
		erase_cell(0,map_info.position)
	else:
		set_cell(0,map_info.position,1,tile_list[id - 1])

	map_info.broadcast(NetworkHandler.connection)


	
# client only updates the position of al the players
func client_handle_map(map_info: MapInfo):

	var id = map_info.tile_id

	if (id == 0):
		erase_cell(0,map_info.position)
	else:
		set_cell(0,map_info.position,1,tile_list[id - 1])
	

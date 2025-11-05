extends Entity


var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id:int


func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_info.connect(server_handle_position)
	ClientNetworkGlobals.handle_player_info.connect(client_handle_position)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_info.disconnect(server_handle_position)
	ClientNetworkGlobals.handle_player_info.disconnect(client_handle_position)


func _physics_process(delta: float) -> void:

	if !is_authority: return

	super._physics_process(delta)

	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * SPEED

	look_at(get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		destroy_tile(get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		place_tile(0,get_global_mouse_position())

	PlayerInfo.create(owner_id,global_position,rotation).send(NetworkHandler.server_peer)


# server updates positions and broadcasts the positions
func server_handle_position(peer_id: int,player_info: PlayerInfo):

	if owner_id != peer_id: return

	global_position = global_position.lerp(player_info.position, 0.3)
	rotation = lerp_angle(rotation, player_info.rotation, 0.3)


	PlayerInfo.create(owner_id,global_position,rotation).broadcast(NetworkHandler.connection)


	
# client only updates the position of al the players
func client_handle_position(player_info: PlayerInfo):

	if is_authority || owner_id != player_info.id: return #only update position of the players packet

	global_position = global_position.lerp(player_info.position, 0.3)
	rotation = lerp_angle(rotation, player_info.rotation, 0.3)

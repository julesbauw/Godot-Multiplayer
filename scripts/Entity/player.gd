extends Entity


var time_accumulated := 0.0
const NETWORK_RATE := 0.05 # 20 Hz, position update send to server per second

var target_position: Vector2

var target_rotation: float

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

	# Other players
	if !is_authority:
		global_position = global_position.lerp(target_position,0.1)
		rotation = lerp_angle(rotation,target_rotation,0.1)
		return

	super._physics_process(delta)

	velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * SPEED

	look_at(get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		destroy_tile(get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		place_tile(0,get_global_mouse_position())

	time_accumulated += delta
	if time_accumulated >= NETWORK_RATE:
		time_accumulated = 0.0
		PlayerInfo.create(owner_id,global_position,rotation).send(NetworkHandler.server_peer)


# server updates positions and broadcasts the positions
func server_handle_position(peer_id: int,player_info: PlayerInfo):

	if owner_id != peer_id: return

	target_position = player_info.position
	target_rotation = player_info.rotation

	PlayerInfo.create(owner_id,global_position,rotation).broadcast(NetworkHandler.connection)


	
# client only updates the position of al the players
func client_handle_position(player_info: PlayerInfo):

	if is_authority || owner_id != player_info.id: return #only update position of the players packet

	target_position = player_info.position
	target_rotation = player_info.rotation

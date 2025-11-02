extends CharacterBody2D


const SPEED: float = 500.0

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

    velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * SPEED

    move_and_slide()

    PlayerInfo.create(owner_id,global_position).send(NetworkHandler.server_peer)



func server_handle_position(peer_id: int,player_info: PlayerInfo):

    if owner_id != peer_id: return

    global_position = player_info.position

    PlayerInfo.create(owner_id,global_position).broadcast(NetworkHandler.connection)


    

func client_handle_position(player_info: PlayerInfo):

    if is_authority || owner_id != player_info.id: return

    global_position = player_info.position


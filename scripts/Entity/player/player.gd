extends Entity

class_name Player

var time_accumulated := 0.0
const NETWORK_RATE := 0.05 # 20 Hz, position update send to server per second

var target_position: Vector2

var target_rotation: float

var is_authority: bool:
	get: return !NetworkHandler.is_server && owner_id == ClientNetworkGlobals.id

var owner_id:int

#Attack

@onready var attack_area:Area2D = $AttackArea

func _enter_tree() -> void:
	ServerNetworkGlobals.handle_player_info.connect(server_handle_position)
	ClientNetworkGlobals.handle_player_info.connect(client_handle_position)
	ServerNetworkGlobals.handle_attack_info.connect(server_handle_attack)
	ClientNetworkGlobals.handle_attack_info.connect(client_handle_attack)

func _exit_tree() -> void:
	ServerNetworkGlobals.handle_player_info.disconnect(server_handle_position)
	ClientNetworkGlobals.handle_player_info.disconnect(client_handle_position)
	ServerNetworkGlobals.handle_attack_info.disconnect(server_handle_attack)
	ClientNetworkGlobals.handle_attack_info.disconnect(client_handle_attack)



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

func attack():
	attack_area.monitoring = true
	await get_tree().create_timer(0.1).timeout  
	attack_area.monitoring = false 

func _on_attack_area_body_entered(body: Node2D) -> void:

	if body is Player:
		if body.owner_id != owner_id:
			var knock_back_dir:Vector2 =(body.global_position - global_position).normalized()
			AttackInfo.create(body.owner_id,knock_back_dir,15,0.33).send(NetworkHandler.server_peer)


func server_handle_attack(peer_id: int,attack_info: AttackInfo):

	if owner_id != attack_info.id: return

	apply_kock_back(attack_info.knock_back_direcion,attack_info.force,attack_info.knock_back_time)

	attack_info.broadcast(NetworkHandler.connection)


	
# client only updates the position of al the players
func client_handle_attack(attack_info:AttackInfo):

	if owner_id != attack_info.id: return #only attack player with the right id

	apply_kock_back(attack_info.knock_back_direcion,attack_info.force,attack_info.knock_back_time)

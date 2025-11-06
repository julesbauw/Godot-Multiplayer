extends Node


signal handle_player_info(peer_id: int, player_info: PlayerInfo)

signal handle_map_info(peer_id: int, map_info: MapInfo)
signal handle_attack_info(peer_id:int,attack_info:AttackInfo)

var peer_ids: Array[int]

func _ready() -> void:
	NetworkHandler.on_peer_connected.connect(on_peer_connected)
	NetworkHandler.on_peer_disconnected.connect(on_peer_disconnected)
	NetworkHandler.on_server_packet.connect(on_server_packet)


func on_peer_connected(peer_id: int) -> void:
	peer_ids.append(peer_id)

	IDAssignment.create(peer_id, peer_ids).broadcast(NetworkHandler.connection)


func on_peer_disconnected(peer_id: int) -> void:
	peer_ids.erase(peer_id)

	# Create IDUnassignment to broadcast to all still connected peers


func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	match data[0]:
		PacketInfo.PACKET_TYPE.PLAYER_INFO:
			handle_player_info.emit(peer_id, PlayerInfo.create_from_data(data))
		PacketInfo.PACKET_TYPE.MAP_INFO:
			handle_map_info.emit(peer_id, MapInfo.create_from_data(data))
		PacketInfo.PACKET_TYPE.ATTACK_INFO:
			handle_attack_info.emit(peer_id,AttackInfo.create_from_data(data))
		_:
			push_error("Packet type with index ", data[0], " unhandled!")
extends PacketInfo

class_name PlayerInfo

#fields
var id: int

var position: Vector2

var rotation: float

static func create(id: int, position: Vector2,rotation:float) -> PlayerInfo:

    var info: PlayerInfo = PlayerInfo.new()
    info.packet_type = PACKET_TYPE.PLAYER_INFO
    info.flag = ENetPacketPeer.FLAG_UNSEQUENCED # UDP packet
    info.id = id
    info.position = position
    info.rotation = rotation

    return info

static func create_from_data(data:PackedByteArray) -> PlayerInfo:
    var info: PlayerInfo = PlayerInfo.new()
    info.decode(data)
    return info


func encode() -> PackedByteArray:
    ### Make packet  |Packet_type|ID| X_Position (4 Bytes) |Y_Position (4 Bytes) | rotation (4 Bytes)
    var data: PackedByteArray = super.encode()

    data.resize(14) # size of the packet is 14 Bytes
    data.encode_u8(1,id) 
    
    data.encode_float(2,position.x)
    data.encode_float(6,position.y)
    data.encode_float(10,rotation)
    return data

func decode(data: PackedByteArray) -> void:
    super.decode(data)
    id = data.decode_u8(1)

    var x = data.decode_float(2)

    var y = data.decode_float(6)

    var new_rotation = data.decode_float(10)

    position = Vector2(x,y)
    rotation = new_rotation

extends PacketInfo

class_name AttackInfo

#fields
var id: int

var knock_back_direcion: Vector2

var force: float

var knock_back_time: float

static func create(attack_id: int, direction:Vector2,force:float,time:float) -> AttackInfo:

    var info: AttackInfo = AttackInfo.new()
    info.packet_type = PACKET_TYPE.ATTACK_INFO
    info.flag = ENetPacketPeer.FLAG_RELIABLE# TCP packet
    info.id = attack_id
    info.knock_back_direcion = direction
    info.force = force
    info.knock_back_time = time

    return info

static func create_from_data(data:PackedByteArray) -> AttackInfo:
    var info: AttackInfo = AttackInfo.new()
    info.decode(data)
    return info


func encode() -> PackedByteArray:
    ### Make packet  |Packet_type|ID| X_DIRECTION (4 Bytes) |Y_Direction (4 Bytes) | force (4 Bytes) | time (4 Bytes)
    var data: PackedByteArray = super.encode()

    data.resize(18) # size of the packet is 14 Bytes
    data.encode_u8(1,id) 
    
    data.encode_float(2,knock_back_direcion.x)
    data.encode_float(6,knock_back_direcion.y)
    data.encode_float(10,force)
    data.encode_float(14,knock_back_time)
    return data

func decode(data: PackedByteArray) -> void:
    super.decode(data)
    id = data.decode_u8(1)

    var x = data.decode_float(2)

    var y = data.decode_float(6)

    force = data.decode_float(10)
    knock_back_time = data.decode_float(14)

    knock_back_direcion = Vector2(x,y)
    

extends PacketInfo

class_name  MapInfo

var position:Vector2i
var tile_id:int

static func create(position: Vector2i,tile_id:int) -> MapInfo:

    var info: MapInfo = MapInfo.new()
    info.packet_type = PACKET_TYPE.MAP_INFO
    info.flag = ENetPacketPeer.FLAG_RELIABLE# TCP packet
    info.position = position
    info.tile_id = tile_id

    return info

static func create_from_data(data:PackedByteArray) -> MapInfo:
    var info: MapInfo = MapInfo.new()
    info.decode(data)
    return info


func encode() -> PackedByteArray:
    # Packet -> Packet_type 1 byte | x 2 Byte | y 2 byte | tile_id
    var data: PackedByteArray = super.encode()

    data.resize(6) # size of the packet is 8 Bytes
    
    data.encode_u16(1,position.x)
    data.encode_u16(3,position.y)
    data.encode_u8(5,tile_id)

    return data

func decode(data: PackedByteArray) -> void:
    super.decode(data)

    var x:int = data.decode_u16(1)

    var y:int = data.decode_u16(3)

    tile_id = data.decode_u8(5)


    position = Vector2i(x,y)
    
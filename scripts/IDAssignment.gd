extends PacketInfo

class_name IDAssignment


var id: int

var remoted_ids: Array[int]

static func create(id: int, remoted_ids: Array[int]) -> IDAssignment:

    var info: IDAssignment = IDAssignment.new()

    info.packet_type = PACKET_TYPE.ID_ASSIGNMENT
    info.flag = ENetPacketPeer.FLAG_RELIABLE ## TCP packet
    
    info.id = id
    info.remoted_ids = remoted_ids

    return info

static func create_from_data(data:PackedByteArray) -> IDAssignment:
    var info: IDAssignment = IDAssignment.new()
    info.decode(data)
    return info

func encode() -> PackedByteArray:
    ### Make packet |packet_type 1 byte|id 1 byte|remoted_id[0] 1 byte |....| remoted_id[n -1] 1 byte
    var data: PackedByteArray = super.encode()

    data.resize(2 + remoted_ids.size()) # size of the packet
    data.encode_u8(1,id)
    
    for i in remoted_ids.size():
        var id: int = remoted_ids[i]
        data.encode_u8(2 + i, id)
    return data

func decode(data: PackedByteArray) -> void:
    super.decode(data)
    id = data.decode_u8(1)
    for i in range(2,data.size()):
        remoted_ids.append(data.decode_u8(i))
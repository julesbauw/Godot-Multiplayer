extends State


@export var entity:Player

@export var return_state:String

func Enter():
    pass

func Exit():
    entity.velocity = Vector2.ZERO
    entity.knock_back_direcion = Vector2.ZERO
    entity.knock_back_force = 0.0
    entity.knock_back_time = 0.0

func Update(_delta: float):
    if entity.knock_back_time <= 0.0:
        Transitioned.emit(self,return_state)

func Physics_Update(_delta: float):

    entity.velocity += entity.knock_back_direcion * entity.knock_back_force

    entity.knock_back_time -= _delta
    PlayerInfo.create(entity.owner_id,entity.global_position,entity.rotation).send(NetworkHandler.server_peer)
    
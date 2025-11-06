extends State

@export var player:Player

const FALL_SPEED:float = 0.95


func Enter():
    player.velocity = Vector2.ZERO
func Exit():
    pass

func Update(_delta: float):
    pass

func Physics_Update(_delta: float):

    player.scale.x *= FALL_SPEED
    player.scale.y *= FALL_SPEED

    pass
    
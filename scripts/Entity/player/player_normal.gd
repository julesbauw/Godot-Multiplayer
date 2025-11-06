extends State

class_name PlayerNormal
@export var player: Player

func Enter():
	pass

func Physics_Update(delta: float):
	# Other players
	if !player.is_authority:
		player.global_position = player.global_position.lerp(player.target_position,0.1)
		player.rotation = lerp_angle(player.rotation,player.target_rotation,0.1)
		return
	player.velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * player.SPEED

	player.look_at(player.get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		player.attack()
		#player.destroy_tile(player.get_global_mouse_position())

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		player.place_tile(0,player.get_global_mouse_position())
	
	player.time_accumulated += delta
	if player.time_accumulated >= player.NETWORK_RATE:
		player.time_accumulated = 0.0
		PlayerInfo.create(player.owner_id,player.global_position,player.rotation).send(NetworkHandler.server_peer)

func Update(_delta: float):
	#check states
	if !player.map.contains_tile(player.global_position):
		Transitioned.emit(self,"player_falling")

	if player.knock_back_time > 0.0:
		Transitioned.emit(self,"player_attacked")

func Exit():
	player.velocity = Vector2.ZERO

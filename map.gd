extends TileMap





func _ready() -> void:

	clear()

	for i in range(8):
		for j in range(8):
			set_cell(0,Vector2i(i,j),1,Vector2i(0,0))


func _process(delta: float) -> void:

	print(local_to_map(get_global_mouse_position()))

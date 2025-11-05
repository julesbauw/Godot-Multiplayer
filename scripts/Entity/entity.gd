extends CharacterBody2D

class_name Entity

@export var SPEED:float = 200.0

@onready var map:Map = get_tree().get_current_scene().get_node_or_null("Map") as Map

func _ready() -> void:
	print(map)
	
func _physics_process(delta: float) -> void:
	if velocity:
		move_and_slide()
	

func destroy_tile(pos:Vector2) -> void:
	map.remove_tile(pos)

func place_tile(tile_id:int,pos:Vector2i) -> void:
	map.place_tile(tile_id,pos)



extends CharacterBody2D

class_name Entity

@export var SPEED:float = 200.0

@onready var map:Map = get_tree().get_current_scene().get_node_or_null("Map") as Map



var knock_back_direcion:Vector2 = Vector2.ZERO

var knock_back_time:float = 0.0

var knock_back_force:float = 0.0


	
func _physics_process(delta: float) -> void:	
	if velocity:
		move_and_slide()

	


func destroy_tile(pos:Vector2) -> void:
	map.remove_tile(pos)

func place_tile(tile_id:int,pos:Vector2i) -> void:
	map.place_tile(tile_id,pos)


func apply_kock_back(direction:Vector2,force:float,time:float):
	knock_back_direcion = direction
	knock_back_force =force
	knock_back_time = time
extends CharacterBody2D

class_name Entity

@export var SPEED:float = 200.0

@onready var map:Map = get_tree().get_current_scene().get_node_or_null("Map") as Map

var falling:bool = false

func _ready() -> void:
	falling = false
	print(map)
	
func _physics_process(delta: float) -> void:
	
	if falling:
		scale.x *= 0.95
		scale.y *= 0.95
		return
	
	if velocity:
		move_and_slide()
	if !map.contains_tile(global_position):
		
		falling = true
	


func destroy_tile(pos:Vector2) -> void:
	map.remove_tile(pos)

func place_tile(tile_id:int,pos:Vector2i) -> void:
	map.place_tile(tile_id,pos)



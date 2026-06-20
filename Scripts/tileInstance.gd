extends Node2D

@export var tile_data: Dictionary
@export var base_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tile_data["height"] >= 1:
		$Area2D/CollisionShape2D.shape = load("res://Assets/Other/tileMouseCheck"+str(tile_data["height"])+".tres")
	$base.set_cell(Vector2i(0,0),0,Vector2i(tile_data["sprite"],0))
	$PlacedOn.set_cell(Vector2i(0,0),0,Vector2i(((tile_data["placedOn"] - 1)*3)+tile_data["height"],0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_area_2d_mouse_entered() -> void:
	GlobalTweaks.current_tile_num = tile_data["number"]

extends Node2D

var mouse_placement: Vector2
var mouse_offset: Vector2
var mouse_down: bool = false
var real_position: Vector2

var map_exists: bool = false

var mouse_press_pos:Vector2 = Vector2(-5000.0,5000.0)

## copyables 
var def_item = {
	"tile": 0,
	"height": 0,
	"sprite": 0,
	"rand_val": randi_range(0,2),
	"clumpID": 0,
	"number": 0,
	"suit": "",
	"placedOn": 0,
	"path": false,
}

var def_clump = {
	"id" :-1,
	"amt" :0,
	"tile" :-1,
}

## generation stuff
var clumps = [
	
]

var numbers = [
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldBuilder.create_map()
	
	var center_tile = Vector2i(
		(WorldBuilder.map_size.x ) / 2,
		(WorldBuilder.map_size.y) / 2
	)
	
	var tile_pos = $Real.map_to_local(center_tile)
	
	real_position = - tile_pos + Vector2(64, 64) + ((get_viewport_rect().size/2)/scale)
	map_exists = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if map_exists:
		print_map()
	
	real_position += mouse_offset
	for child in get_children():
		if child.is_in_group("Tiles"):
			if child.name == "Water":
				child.position = Vector2(
					-64 + fposmod(real_position.x, 32.0),
					-64 + fposmod(real_position.y, 36.0)
				)
			else:
				child.position = Vector2(
					-64 + real_position.x,
					-64 + real_position.y
				)
	
	@warning_ignore("int_as_enum_without_cast")
	if Input.is_mouse_button_pressed(1):
		if mouse_down == false:
			mouse_placement = get_global_mouse_position()
		mouse_down = true
	else:
		mouse_down = false
		mouse_offset = Vector2(0.0,0.0)
		
	if mouse_down:
		mouse_offset = (get_global_mouse_position() - mouse_placement) / scale
		mouse_placement = get_global_mouse_position()
	
	if Input.is_action_pressed("Click") and mouse_press_pos == Vector2(-5000.0,5000.0):
		mouse_press_pos = mouse_placement
	
	var pos = $Real.local_to_map($Real.to_local(get_global_mouse_position()))
	if WorldBuilder.on_edge(pos.x, pos.y) and Input.is_action_just_released("Click") and not GlobalTweaks.on_ui:
		GlobalTweaks.current_tile_num = pos

func in_distance(item,target,r) -> bool:
	return abs(item - target) <= r

func get_production_number():
	pass

func print_map():
	$Real.clear()
	$Paths.clear()
	$PlacedOn.clear()
	for y in range(WorldBuilder.map_size.y):
		for x in range(WorldBuilder.map_size.x):
			$Real.set_cell(Vector2i(x,y),9,Vector2i(WorldBuilder.map_data[y][x].get("sprite"),0))
			if WorldBuilder.map_data[y][x].get("placedOn") != 0:
				$PlacedOn.set_cell(Vector2i(x,y),0,Vector2i((((WorldBuilder.map_data[y][x].get("placedOn") - 1) * 3) + 1),0))
			if WorldBuilder.map_data[y][x].get("path"):
				$Paths.set_cell(Vector2i(x,y),0,Vector2i(0,0))
			

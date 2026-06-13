extends Node2D

var mouse_placement: Vector2
var mouse_offset: Vector2
var mouse_down: bool = false
var real_position: Vector2

var def_item = {
	"tile": 0,
	"height": 0,
	"sprite": 0,
	"rand_val": 1,
}
var map_data: Array
var map_size = Vector2(40,60)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_map()
	print_map()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func generate_noise(min,max) -> Array:
	var ret = []
	var current_line = []
	for y in range(map_size.y):
		current_line = []
		for x in range(map_size.x):
			current_line.append(randi_range(min,max))
		ret.append(current_line)
	return ret

func on_edge(x,y) -> bool:
	var r = true
	
	if x < 0:
		r=false
	if y<0:
		r=false
	if x>=map_size.x - 1:
		r=false
	if y>=map_size.y - 1:
		r=false
	
	return r

func get_return(noise,x,y, type) -> int:
	if type == "noise":
		var a = 0
		var b = 0
		var c = 0
		
		for ay in range(y-1,y+2):
			for ax in range(x-1,x+1):
				if on_edge(ax,ay):
					match noise[ay][ax+1]:
						0:
							a+=1
						1:
							b+=1
						2:
							c+=1
		if on_edge(x+1,y):
					match noise[y][x+1]:
						0:
							a+=1
						1:
							b+=1
						2:
							c+=1
	
		if a>b and a>c:
			return 0
		if b>a and b>c:
			return 1
		if c>a and c>b:
			return 2
		return 1
	return 1

func smooth(noise: Array, type) -> Array:
	for y in range(noise.size()):
		for x in range(noise[0].size()):
			noise[y][x] = get_return(noise,x,y,type)
	return noise

func create_map():
	var noise = generate_noise(0,2)
	var biomes = generate_noise(0,4)
	var current_line = []
	
	for i in range(GlobalTweaks.smoothness):
		noise = smooth(noise, "noise")
		biomes = smooth(biomes, "biome")
	
	map_data = []
	var current_item = {}
	for y in range(map_size.y):
		current_line = []
		for x in range(map_size.x):
			current_item = def_item.duplicate()
			current_item["height"] = noise[y][x]
			current_item["tile"] = randi_range(1,5)
			current_item["sprite"] = current_item["tile"] + (current_item["height"] * 6)
			current_item["rand_val"] = randi_range(0,2)
			
			current_line.append(current_item)
		map_data.append(current_line)
		
func print_map():
	$Real.clear()
	for y in range(map_size.y):
		for x in range(map_size.x):
			
			$Real.set_cell(Vector2i(x,y),9,Vector2i(map_data[y][x].get("sprite"),0))

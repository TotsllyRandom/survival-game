extends Node2D

var mouse_placement: Vector2
var mouse_offset: Vector2
var mouse_down: bool = false
var real_position: Vector2

var map_exists: bool = false

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

var map_data: Array
var map_size = Vector2(40,60)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_map()
	
	var center_tile = Vector2i(
		(map_size.x ) / 2,
		(map_size.y) / 2
	)
	
	var tile_pos = $Real.map_to_local(center_tile)
	
	real_position = - tile_pos + Vector2(64, 64)
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
	
	var pos = $Real.local_to_map($Real.to_local(get_global_mouse_position()))
	if on_edge(pos.x, pos.y):
		GlobalTweaks.current_tile_num = pos
		
		@warning_ignore("int_as_enum_without_cast")
		if Input.is_action_just_pressed("Click"):
			map_data[pos.y][pos.x]["placedOn"] = 4

func generate_noise(mi,ma) -> Array:
	var ret = []
	var current_line = []
	for y in range(map_size.y):
		current_line = []
		for x in range(map_size.x):
			current_line.append(randi_range(mi,ma))
		ret.append(current_line)
	return ret

func on_edge(x,y) -> bool:
	return x >= 0 and x < map_size.x and y >= 0 and y < map_size.y

func get_neighbors(pos: Vector2i) -> Array:
	var ret = []

	if pos.y % 2 == 0:
		ret = append_if_okay(Vector2i(pos.x - 1, pos.y+1),ret)
		ret = append_if_okay(Vector2i(pos.x - 1, pos.y-1),ret)
	else:
		ret = append_if_okay(Vector2i(pos.x + 1, pos.y+1),ret)
		ret = append_if_okay(Vector2i(pos.x + 1, pos.y-1),ret)
	
	ret = append_if_okay(Vector2i(pos.x + 1, pos.y),ret)
	ret = append_if_okay(Vector2i(pos.x-1, pos.y),ret)
	
	ret = append_if_okay(Vector2i(pos.x, pos.y + 1),ret)
	ret = append_if_okay(Vector2i(pos.x, pos.y - 1),ret)
	
	return ret

func append_if_okay(pos: Vector2i,ret: Array) -> Array:
	if pos.x < 0 or pos.x >= map_size.x or pos.y < 0 or pos.y >= map_size.y:
		return ret
	ret.append(pos)
	return ret

func shift_neighbors_to_clumps(ret: Array, cline:Array, r:Array) -> Array:
	var a = []
	for pos in ret:
		if pos.y == r.size():
			if pos.x >= cline.size():
				continue
			else:
				a.append(cline[pos.x])
		elif pos.y > r.size():
			continue
		else:
			a.append(r[pos.y][pos.x])
	return a

func generate_biome_noise() -> Array:
	var ret = []
	clumps.clear()
	
	## empty map -> define clumps -> define biomes
	for y in range(map_size.y):
		var currentLine = []
		for x in range(map_size.x):
			var possible = []
			var neighbors = shift_neighbors_to_clumps(get_neighbors(Vector2i(x,y)),currentLine,ret)
			
			for neighbor in neighbors:
				possible.append(clumps[neighbor]["id"])
			possible.append(clumps.size())
			if possible == []:
				currentLine.append(clumps.size())
				clumps.append(def_clump.duplicate())
				clumps[clumps.size()-1]["id"] = clumps.size()-1
				clumps[clumps.size()-1]["amt"] = 1
			else:
				var i = possible[randi_range(0,possible.size()-1)]
				if i == clumps.size():
					clumps.append(def_clump.duplicate())
					clumps[clumps.size()-1]["id"] = clumps.size()-1
					clumps[clumps.size()-1]["amt"] = 0
				currentLine.append(i)
				clumps[i]["amt"] = clumps[i]["amt"] + 1
		ret.append(currentLine)
	return ret

func get_return(noise,x,y) -> int:

	var counts = [0,0,0]

	for ay in range(y-1,y+2):
		for ax in range(x-1,x+2):

			if on_edge(ax,ay):

				var v = noise[ay][ax]

				if v >= 0 and v <= 2:
					counts[v] += 1

	var best = 0

	for i in range(1,3):
		if counts[i] > counts[best]:
			best = i

	return best



func smooth(noise: Array) -> Array:

	var ret = noise.duplicate(true)

	for y in range(noise.size()):
		for x in range(noise[0].size()):
			ret[y][x] = get_return(noise,x,y)

	return ret

func smooth_clumps(biomes: Array):
	for clump in clumps:
		while clump["amt"] > 7:
			var rand_tile = Vector2i(randi_range(0,biomes[0].size()-1),randi_range(0,biomes.size()-1))
			if biomes[rand_tile.y][rand_tile.x] == clump["id"]:
				var n = get_neighbors(rand_tile)
				var fixed = []
				for a in range(n.size()):
					if biomes[n[a].y][n[a].x] > clump["id"]:
						fixed.append(n[a])
				if fixed.size() > 0:
					var chosen = randi_range(0,fixed.size()-1)
					biomes[rand_tile.y][rand_tile.x] = biomes[fixed[chosen].y][fixed[chosen].x]
					var target_clump = biomes[fixed[chosen].y][fixed[chosen].x]
					clumps[target_clump]["amt"] += 1
				else:
					clumps.append(def_clump.duplicate())
					clumps[clumps.size()-1]["id"] = clumps.size()-1
					clumps[clumps.size()-1]["amt"] = 1
					biomes[rand_tile.y][rand_tile.x] = clumps.size()-1
				clump["amt"] -= 1
			
	return biomes

func create_map():

	var noise = generate_noise(0,2)
	var biomes = generate_biome_noise()
	
	biomes = smooth_clumps(biomes)
	
	for clump in range(clumps.size() - 1, -1, -1):
		clumps[clump]["tile"] = randi_range(0,GlobalTweaks.BIOMES.size()-1)
		if clumps[clump]["amt"] == 0:
			clumps.pop_at(clump)

	for i in range(GlobalTweaks.smoothness):
		noise = smooth(noise)

	map_data = []
	
	clumps.append(def_clump.duplicate())
	clumps[clumps.size()-1]["id"] = clumps[clumps.size()-1]["id"] + 1
	clumps[clumps.size()-1]["amt"] = 1
	clumps[clumps.size()-1]["tile"] = 5
	
	for y in range(map_size.y):
		var current_line = []
		
		for x in range(map_size.x):
			var current_item = def_item.duplicate()
			
			if x == (map_size.x)/2 and y == (map_size.y)/2:
				current_item["clumpID"] = clumps.size() -1
				current_item["tile"] = 5
			else:
				current_item["clumpID"] = biomes[y][x]
				current_item["tile"] = clumps[current_item["clumpID"]]["tile"]
			
			current_item["height"] = noise[y][x]
			
			##if x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y -1:
			##	clumps[current_item["clumpID"]]["tile"] = 0
			
			current_item["number"] = choose_number()
			numbers[current_item["number"] - 1] += 1
			
			current_item["sprite"] = ((current_item["tile"] * 3) + (current_item["height"]))
			
			current_item["rand_val"] = randi_range(0,2)
			current_item["placedOn"] = GlobalTweaks.BIOMES[current_item["tile"]].get("placedOn", 0)
			
			current_line.append(current_item)
		
		map_data.append(current_line)
	
	map_data[(map_size.y)/2][(map_size.x)/2]["placedOn"] = 4

func choose_number() -> int:
	var lowest = []
	var num = 10000000
	
	for n in range(numbers.size()):
		if numbers[n] < num:
			lowest = [n+1]
			num = numbers[n]
		elif numbers[n] == num:
			lowest.append(n+1)
	
	return lowest[randi_range(0,lowest.size()-1)]

func print_map():
	$Real.clear()
	for y in range(map_size.y):
		for x in range(map_size.x):
			$Real.set_cell(Vector2i(x,y),9,Vector2i(map_data[y][x].get("sprite"),0))
			if map_data[y][x].get("placedOn") != 0:
				$PlacedOn.set_cell(Vector2i(x,y),0,Vector2i(((map_data[y][x].get("placedOn") - 1) * 3) + (map_data[y][x].get("height")),0))
			

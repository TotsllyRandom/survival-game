extends Node

var current_tile_num = 0

const BIOMES = [
	
	{
		"name": "desert",
		"produce": [
			
		],
		"max": 3
	},
	{
		"name": "field",
		"produce": [
			"grain"
		],
		"min": 5
	},
	{
		"name": "mine",
		"produce": [
			"ore"
		],
		"min": 5
	},
	{
		"name": "pasture",
		"produce": [
			"wool"
		],
		"min": 5,
		##"placedOn": 
	},
	{
		"name": "mesa",
		"produce": [
			"brick"
		],
		"min": 5
	},
	{
		"name": "forest",
		"produce": [
			"wood"
		],
		"min": 5
	},
	
]

## Keep settings here that players can change that tweak world gen. This may go into a world gen seed?

var smoothness = 5

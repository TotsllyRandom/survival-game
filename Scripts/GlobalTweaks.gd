extends Node

var current_tile_num = 0
var real_position


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
		"min": 5,
		"placedOn": 0
	},
	{
		"name": "mine",
		"produce": [
			"ore"
		],
		"min": 5,
		"placedOn": 0
	},
	{
		"name": "pasture",
		"produce": [
			"wool"
		],
		"min": 5,
		"placedOn": 1
	},
	{
		"name": "mesa",
		"produce": [
			"brick"
		],
		"min": 5,
		"placedOn": 0
	},
	{
		"name": "forest",
		"produce": [
			"wood"
		],
		"min": 5,
		"placedOn": 2,
	},
	
]

## Keep settings here that players can change that tweak world gen. This may go into a world gen seed?

var smoothness = 5

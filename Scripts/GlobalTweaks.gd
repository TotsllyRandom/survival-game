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
		"placedOn": 3
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

const PLACEABLES = [
	{
		"name": "sheep",
	},
	{
		"name": "trees",
	},
	{
		"name": "jagged stones",
	},
	{
		"name": "hut",
		"mult": 1,
		"cost": {
			"wood" : 10,
			"brick" : 10,
		},
	},
	{
		"name": "barracks",
		"mult": .5,
		"cost": {
			"wool" : 10,
			"grain" : 10,
			"wood" : 25,
		},
	},
]

const RESOURCES = [
	{
		"name": "wood",
	},
	{
		"name": "brick",
	},
	{
		"name": "wool",
	},
	{
		"name": "ore",
	},
	{
		"name": "grain",
	},
]

## Keep settings here that players can change that tweak world gen. This may go into a world gen seed?

var smoothness = 5

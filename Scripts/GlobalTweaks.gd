extends Node


const BIOMES = [
	
	{
		"name": "desert",
		"produce": [
			
		],
	},
	{
		"name": "field",
		"produce": [
			"grain"
		],
	},
	{
		"name": "mine",
		"produce": [
			"ore"
		],
	},
	{
		"name": "pasture",
		"produce": [
			"wool"
		],
	},
	{
		"name": "mesa",
		"produce": [
			"brick"
		],
	},
	{
		"name": "forest",
		"produce": [
			"wood"
		],
	},
	
]

## Keep settings here that players can change that tweak world gen. This may go into a world gen seed?

var smoothness = 5

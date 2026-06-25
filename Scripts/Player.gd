extends Node

var resources = GlobalTweaks.RESOURCES.duplicate(true)

func _ready():
	for resource in resources:
		resource["amount"] = 0
